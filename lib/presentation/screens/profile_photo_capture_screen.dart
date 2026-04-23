import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/face_recognition_bloc.dart';
import 'package:sip_sales_clean/presentation/widgets/camera/camera_preview_widget.dart';
import 'package:sip_sales_clean/presentation/widgets/camera/liveness_instruction_widget.dart';

class ProfilePhotoCaptureScreen extends StatefulWidget {
  const ProfilePhotoCaptureScreen({super.key});

  @override
  State<ProfilePhotoCaptureScreen> createState() =>
      _ProfilePhotoCaptureScreenState();
}

class _ProfilePhotoCaptureScreenState extends State<ProfilePhotoCaptureScreen> {
  CameraController? _cameraController;
  bool _isCameraReady = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();

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

    context.read<FaceRecognitionBloc>().add(StartProfileCapture());

    _cameraController!.startImageStream((image) {
      context.read<FaceRecognitionBloc>().add(
        ProcessCameraFrame(
          image: image,
          sensorOrientation: frontCamera.sensorOrientation,
          isFrontCamera: true,
        ),
      );
    });
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || _isCapturing) return;
    setState(() => _isCapturing = true);
    final photo = await _cameraController!.takePicture();
    if (mounted) Navigator.of(context).pop(photo);
  }

  void _close() {
    context.read<FaceRecognitionBloc>().add(StopVerification());
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // _cameraController?.stopImageStream();
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
          'Foto Profil',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: _close,
        ),
      ),
      body: SafeArea(
        child: Column(
          spacing: 12,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: _isCameraReady && _cameraController != null
                    ? CameraPreviewWidget(controller: _cameraController!)
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
              ),
            ),

            Expanded(
              flex: 1,
              child: BlocConsumer<FaceRecognitionBloc, FaceRecognitionState>(
                listener: (context, state) {
                  if (state is FaceReadyForCapture) {
                    // Stop the stream — face is validated, freeze the preview
                    _cameraController?.stopImageStream();
                  }
                },
                builder: (context, state) {
                  if (state is FaceReadyForCapture) {
                    return Center(
                      child: SizedBox(
                        width: 200,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isCapturing ? null : _capturePhoto,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text(
                            'Ambil Foto',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return switch (state) {
                    VerificationInProgress(
                      :final instruction,
                      :final faceDetected,
                      :final livenessOk,
                    ) =>
                      LivenessInstructionWidget(
                        instruction: instruction,
                        faceDetected: faceDetected,
                        livenessOk: livenessOk,
                      ),
                    _ => const SizedBox.shrink(),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
