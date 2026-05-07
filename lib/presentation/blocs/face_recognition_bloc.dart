import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:sip_sales_clean/core/constant/face_recognition_constants.dart';

import '../../core/helpers/image_helper.dart';
import '../../domain/usecases/enroll_face_usecase.dart';
import '../../domain/usecases/verify_face_usecase.dart';
import '../functions.dart';

// ── Events ──

sealed class FaceRecognitionEvent {}

class InitializeCamera extends FaceRecognitionEvent {}

class EnrollFace extends FaceRecognitionEvent {
  final String userId;
  final String base64Image;
  EnrollFace({required this.userId, required this.base64Image});
}

class ProcessCameraFrame extends FaceRecognitionEvent {
  final CameraImage image;
  final int sensorOrientation;
  final bool isFrontCamera;
  ProcessCameraFrame({
    required this.image,
    required this.sensorOrientation,
    required this.isFrontCamera,
  });
}

class StartVerification extends FaceRecognitionEvent {
  final String userId;
  final VerificationMethod method;
  StartVerification({
    required this.userId,
    this.method = VerificationMethod.regula,
  });
}

class StopVerification extends FaceRecognitionEvent {}

class StartProfileCapture extends FaceRecognitionEvent {}

// ── States ──

sealed class FaceRecognitionState {}

class FaceRecognitionInitial extends FaceRecognitionState {}

class FaceRecognitionLoading extends FaceRecognitionState {
  final String message;
  FaceRecognitionLoading({this.message = 'Loading...'});
}

class EnrollmentSuccess extends FaceRecognitionState {}

class EnrollmentFailure extends FaceRecognitionState {
  final String error;
  EnrollmentFailure({required this.error});
}

class VerificationInProgress extends FaceRecognitionState {
  final String instruction;
  final bool faceDetected;
  final bool livenessOk;

  VerificationInProgress({
    required this.instruction,
    this.faceDetected = false,
    this.livenessOk = false,
  });
}

class VerificationSuccess extends FaceRecognitionState {
  final double score;
  VerificationSuccess({required this.score});
}

class VerificationFailure extends FaceRecognitionState {
  final String reason;
  final double? score;
  VerificationFailure({required this.reason, this.score});
}

class FaceReadyForCapture extends FaceRecognitionState {}

// ── BLoC ──

class FaceRecognitionBloc
    extends Bloc<FaceRecognitionEvent, FaceRecognitionState> {
  final EnrollFaceUseCase _enrollFaceUseCase;
  final VerifyFaceUseCase _verifyFaceUseCase;
  final FaceDetector _faceDetector;

  String? _activeUserId;
  bool _isProcessing = false;
  bool _captureMode = false;
  VerificationMethod _activeMethod = VerificationMethod.regula;

  FaceRecognitionBloc({
    required EnrollFaceUseCase enrollFaceUseCase,
    required VerifyFaceUseCase verifyFaceUseCase,
    required FaceDetector faceDetector,
  }) : _enrollFaceUseCase = enrollFaceUseCase,
       _verifyFaceUseCase = verifyFaceUseCase,
       _faceDetector = faceDetector,
       super(FaceRecognitionInitial()) {
    on<EnrollFace>(_onEnrollFace);
    on<StartVerification>(_onStartVerification);
    on<StartProfileCapture>(_onStartProfileCapture);
    on<StopVerification>(_onStopVerification);
    on<ProcessCameraFrame>(_onProcessCameraFrame);
  }

  @override
  Future<void> close() async {
    // Do NOT close _faceDetector here — it is a shared instance owned by
    // FaceRecognitionDependencies. Closing it here would break enrollment
    // and any subsequent verification in the global bloc after screen pop.
    return super.close();
  }

  Future<void> _onEnrollFace(
    EnrollFace event,
    Emitter<FaceRecognitionState> emit,
  ) async {
    emit(FaceRecognitionLoading(message: 'Enrolling face...'));
    try {
      final result = await _enrollFaceUseCase(
        userId: event.userId,
        base64Image: event.base64Image,
      );
      if (result == null) {
        log('Enrollment skipped: no face detected in profile photo');
        // Functions.customFlutterToast('Foto profil tidak terdeteksi wajah. Pendaftaran wajah dilewati.');
        emit(FaceRecognitionInitial());
        return;
      }
      log('Enrollment success');
      emit(EnrollmentSuccess());
    } on EnrollmentException catch (e) {
      log('Enrollment failed: $e');
      emit(EnrollmentFailure(error: e.message));
    } catch (e) {
      log('Enrollment failed: $e');
      emit(EnrollmentFailure(error: 'Unexpected error: $e'));
    }
  }

  Future<void> _onStartVerification(
    StartVerification event,
    Emitter<FaceRecognitionState> emit,
  ) async {
    _activeUserId = event.userId;
    _activeMethod = event.method;
    log('Verification method: $_activeMethod');
    emit(
      VerificationInProgress(instruction: 'Position your face in the frame'),
    );
  }

  void _onStartProfileCapture(
    StartProfileCapture event,
    Emitter<FaceRecognitionState> emit,
  ) {
    _captureMode = true;
    _activeUserId = ''; // non-null so the frame guard passes
    emit(
      VerificationInProgress(instruction: 'Position your face in the frame'),
    );
  }

  void _onStopVerification(
    StopVerification event,
    Emitter<FaceRecognitionState> emit,
  ) {
    _activeUserId = null;
    _captureMode = false;
    _isProcessing = false;
    emit(FaceRecognitionInitial());
  }

  Future<void> _onProcessCameraFrame(
    ProcessCameraFrame event,
    Emitter<FaceRecognitionState> emit,
  ) async {
    if (_isProcessing || _activeUserId == null) return;
    _isProcessing = true;

    try {
      // 1. Build InputImage for ML Kit directly from raw camera planes (fast)
      final imageBytes = Uint8List.fromList(
        event.image.planes.expand((plane) => plane.bytes).toList(),
      );

      final inputImage = InputImage.fromBytes(
        bytes: imageBytes,
        metadata: InputImageMetadata(
          size: Size(
            event.image.width.toDouble(),
            event.image.height.toDouble(),
          ),
          rotation: _rotationFromSensorOrientation(event.sensorOrientation),
          format: switch (event.image.format.group) {
            ImageFormatGroup.bgra8888 => InputImageFormat.bgra8888,
            ImageFormatGroup.nv21 => InputImageFormat.nv21,
            _ => InputImageFormat.yuv_420_888,
          },
          bytesPerRow: event.image.planes[0].bytesPerRow,
        ),
      );
      log('Verification phase 1 passed');

      // 2. Detect faces
      final faces = await _faceDetector.processImage(inputImage);
      if (faces.isEmpty) {
        emit(
          VerificationInProgress(
            instruction: 'No face detected. Look at the camera.',
            faceDetected: false,
          ),
        );
        _isProcessing = false;
        return;
      }

      if (faces.length > 1) {
        emit(
          VerificationInProgress(
            instruction: 'Multiple faces detected. Only one person please.',
            faceDetected: false,
          ),
        );
        _isProcessing = false;
        return;
      }
      log('Verification phase 2 passed');

      final face = faces.first;

      // 3. Oval position check
      if (!_isFaceInsideOval(face, event.image, event.sensorOrientation)) {
        emit(
          VerificationInProgress(
            instruction: 'Posisikan wajah di dalam lingkaran.',
            faceDetected: true,
            livenessOk: false,
          ),
        );
        _isProcessing = false;
        return;
      }
      log('Verification phase 3 passed');

      // 4. Liveness check
      if (!_passesLivenessCheck(face)) {
        emit(
          VerificationInProgress(
            instruction: 'Look directly at the camera with eyes open.',
            faceDetected: true,
            livenessOk: false,
          ),
        );
        _isProcessing = false;
        return;
      }

      emit(
        VerificationInProgress(
          instruction: 'Verifying...',
          faceDetected: true,
          livenessOk: true,
        ),
      );

      // Capture mode: all checks passed — no image conversion needed
      if (_captureMode) {
        emit(FaceReadyForCapture());
        _isProcessing = false;
        return;
      }
      log('Verification phase 4 passed');

      // 5. Convert image — deferred until all checks pass to avoid running
      //    the expensive YUV→RGB pixel loop on frames that would be rejected.
      final fullCameraImage = ImageHelper.convertCameraImage(event.image);
      if (fullCameraImage == null) {
        _isProcessing = false;
        return;
      }
      log('Verification phase 6 passed');

      // 6. Crop face and verify
      final croppedCameraFace = ImageHelper.cropFace(
        fullCameraImage,
        face.boundingBox,
      );
      log('Verification phase 6 passed');

      final (:result, :score) = await _verifyFaceUseCase(
        userId: _activeUserId!,
        croppedFace: croppedCameraFace,
        method: _activeMethod,
      );

      switch (result) {
        case VerificationResult.match:
          _activeUserId = null;
          emit(VerificationSuccess(score: score));
        case VerificationResult.noMatch:
          emit(
            VerificationFailure(reason: 'Face does not match.', score: score),
          );
        case VerificationResult.noReferenceFound:
          emit(
            VerificationFailure(
              reason: 'No enrolled face found. Please enroll first.',
            ),
          );
        case VerificationResult.extractionFailed:
          emit(
            VerificationFailure(reason: 'Could not process face. Try again.'),
          );
      }
    } catch (e) {
      log('onProcessCameraFrame error: ${e.toString()}');
      emit(VerificationFailure(reason: 'Error: $e'));
    } finally {
      _isProcessing = false;
    }
  }

  /// Returns true if the face center falls inside the oval guide overlay.
  /// Converts face bounding box from raw sensor coordinates to normalized
  /// portrait display coordinates, then checks the ellipse equation.
  bool _isFaceInsideOval(Face face, CameraImage image, int sensorOrientation) {
    final double normX;
    final double normY;

    // Map raw sensor coords → normalized portrait [0,1] based on rotation
    switch (sensorOrientation) {
      case 90:
        normX = 1.0 - face.boundingBox.center.dy / image.height;
        normY = face.boundingBox.center.dx / image.width;
      case 270:
        normX = face.boundingBox.center.dy / image.height;
        normY = 1.0 - face.boundingBox.center.dx / image.width;
      default: // 0° or 180°
        normX = face.boundingBox.center.dx / image.width;
        normY = face.boundingBox.center.dy / image.height;
    }

    // Oval from _FaceGuidePainter: center (0.5, 0.42), semi-axes both 0.3
    // in normalized [0,1] space (3:4 widget ratio makes them equal).
    // r=0.4 adds ~33% tolerance over the drawn oval edge (0.3) to absorb
    // minor head movement and per-device calibration differences.
    const cx = 0.5, cy = 0.42, r = 0.4;
    final dx = (normX - cx) / r;
    final dy = (normY - cy) / r;
    log(
      'NormX: ${normX.toString()}; NormY: ${normY.toString()}; dx: ${dx.toString()}; dy: ${dy.toString()}; result: ${(dx * dx + dy * dy)}, ${(dx * dx + dy * dy) <= 1.0}',
    );
    return (dx * dx + dy * dy) <= 1.0;
  }

  bool _passesLivenessCheck(Face face) {
    final leftEye = face.leftEyeOpenProbability ?? 0;
    final rightEye = face.rightEyeOpenProbability ?? 0;
    final rotY = face.headEulerAngleY ?? 0;
    final rotZ = face.headEulerAngleZ ?? 0;

    if (leftEye < FaceRecognitionConstants.eyeOpenThreshold) return false;
    if (rightEye < FaceRecognitionConstants.eyeOpenThreshold) return false;
    if (rotY.abs() > FaceRecognitionConstants.maxHeadRotationY) return false;
    if (rotZ.abs() > FaceRecognitionConstants.maxHeadRotationZ) return false;

    return true;
  }

  InputImageRotation _rotationFromSensorOrientation(int orientation) {
    switch (orientation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }
}
