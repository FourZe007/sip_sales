import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/widgets/camera/camera_preview_widget.dart';
import 'package:sip_sales_clean/presentation/widgets/camera/liveness_instruction_widget.dart';

import '../blocs/face_recognition_bloc.dart';

class FaceVerificationScreen extends StatefulWidget {
  /// The user ID to verify against.
  final String userId;

  /// Callback when verification succeeds — hook this to your attendance API.
  final VoidCallback onVerificationSuccess;

  const FaceVerificationScreen({
    super.key,
    required this.userId,
    required this.onVerificationSuccess,
  });

  @override
  State<FaceVerificationScreen> createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen> {
  CameraController? _cameraController;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();

    // Use front camera
    final frontCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isIOS
          ? ImageFormatGroup.bgra8888
          : ImageFormatGroup.nv21,
    );

    await _cameraController!.initialize();

    if (!mounted) return;

    setState(() => _isCameraReady = true);

    // Start verification and frame processing
    context.read<FaceRecognitionBloc>().add(
      StartVerification(userId: widget.userId),
    );

    await _cameraController!.startImageStream((image) {
      context.read<FaceRecognitionBloc>().add(
        ProcessCameraFrame(
          image: image,
          sensorOrientation: frontCamera.sensorOrientation,
          isFrontCamera: true,
        ),
      );
    });
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Verify Attendance',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            context.read<FaceRecognitionBloc>().add(StopVerification());
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            spacing: 12,
            children: [
              // Camera preview with face guide
              Expanded(
                flex: 3,
                child: _isCameraReady && _cameraController != null
                    ? CameraPreviewWidget(controller: _cameraController!)
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
              ),

              // Status / instruction area
              Expanded(
                flex: 1,
                child: BlocConsumer<FaceRecognitionBloc, FaceRecognitionState>(
                  listener: (context, state) {
                    if (state is VerificationSuccess) {
                      widget.onVerificationSuccess();
                      Navigator.of(context).pop();
                    } else if (state is VerificationFailure) {
                      log('Face Verification failed: ${state.reason}');
                    }
                  },
                  builder: (context, state) {
                    return switch (state) {
                      // Case 1
                      VerificationInProgress(
                        :final instruction, // equal to state.instruction
                        :final faceDetected, // equal to state.faceDetected
                        :final livenessOk, // equal to state.livenessOk
                      ) =>
                        LivenessInstructionWidget(
                          instruction: instruction,
                          faceDetected: faceDetected,
                          livenessOk: livenessOk,
                        ),

                      // Case 2
                      VerificationFailure(:final reason, :final score) =>
                        SingleChildScrollView(
                          child: Column(
                            spacing: 8,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LivenessInstructionWidget(
                                instruction: reason,
                                faceDetected: false,
                              ),
                              if (score != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Similarity: ${(score * 100).toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(100),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                              TextButton(
                                onPressed: () {
                                  context.read<FaceRecognitionBloc>().add(
                                    StartVerification(userId: widget.userId),
                                  );
                                },
                                child: Text(
                                  'Retry',
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(100),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Case 3
                      VerificationSuccess(:final score) => SingleChildScrollView(
                        child: Column(
                          spacing: 8,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 48,
                            ),

                            Text(
                              'Verified! (${(score * 100).toStringAsFixed(1)}%)',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Case 4
                      FaceRecognitionLoading(:final message) => Center(
                        child: Text(
                          message,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      _ => const SizedBox.shrink(), // default case
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
