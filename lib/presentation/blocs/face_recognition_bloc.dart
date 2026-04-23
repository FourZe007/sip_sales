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
    await _faceDetector.close();
    return super.close();
  }

  Future<void> _onEnrollFace(
    EnrollFace event,
    Emitter<FaceRecognitionState> emit,
  ) async {
    emit(FaceRecognitionLoading(message: 'Enrolling face...'));
    try {
      await _enrollFaceUseCase(
        userId: event.userId,
        base64Image: event.base64Image,
      );
      emit(EnrollmentSuccess());
    } on EnrollmentException catch (e) {
      emit(EnrollmentFailure(error: e.message));
    } catch (e) {
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
      // 1. Convert camera image
      final fullCameraImage = ImageHelper.convertCameraImage(event.image);
      if (fullCameraImage == null) {
        log('fullImage is null');
        _isProcessing = false;
        return;
      }
      log('Phase 1 passed');

      // 2. Build InputImage for ML Kit — combine all planes (Y + UV for NV21)
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
      log('Phase 2 passed');

      // 3. Detect faces
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
      log('Phase 3 passed');

      final face = faces.first;

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
      log('Phase 4 passed. emitting the verification result.');

      emit(
        VerificationInProgress(
          instruction: 'Verifying...',
          faceDetected: true,
          livenessOk: true,
        ),
      );

      // Capture mode: face + liveness validated — let the screen take the photo
      if (_captureMode) {
        emit(FaceReadyForCapture());
        _isProcessing = false;
        return;
      }

      // 5. Crop face and verify
      final croppedCameraFace = ImageHelper.cropFace(
        fullCameraImage,
        face.boundingBox,
      );
      log('Phase 5 passed');

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
