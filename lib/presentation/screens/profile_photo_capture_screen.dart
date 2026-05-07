import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sip_sales_clean/presentation/blocs/face_recognition_bloc.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
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
  CameraDescription? _frontCamera;
  bool _isCameraReady = false;

  final PanelController _panelController = PanelController();
  XFile? _capturedPhoto;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();

    _frontCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      _frontCamera!,
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
          sensorOrientation: _frontCamera!.sensorOrientation,
          isFrontCamera: true,
        ),
      );
    });
  }

  Future<void> _capturePhoto(bool isFaceDetected) async {
    if (!isFaceDetected) {
      Functions.customFlutterToast('Coba lagi! Wajah tidak terdeteksi.');
      return;
    }
    if (_cameraController == null) return;
    _cameraController!.stopImageStream();
    _cameraController!.pausePreview();
    final photo = await _cameraController!.takePicture();
    setState(() => _capturedPhoto = photo);
    _panelController.open();
  }

  void _confirmPhoto() {
    context.read<FaceRecognitionBloc>().add(StopVerification());
    Navigator.of(context).pop(_capturedPhoto);
  }

  Future<void> _retryPhoto() async {
    _panelController.close();
    setState(() => _capturedPhoto = null);
    _cameraController!.resumePreview();
    context.read<FaceRecognitionBloc>().add(StartProfileCapture());
    await _cameraController!.startImageStream((image) {
      context.read<FaceRecognitionBloc>().add(
        ProcessCameraFrame(
          image: image,
          sensorOrientation: _frontCamera!.sensorOrientation,
          isFrontCamera: true,
        ),
      );
    });
  }

  void _close() {
    _cameraController?.stopImageStream();
    context.read<FaceRecognitionBloc>().add(StopVerification());
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Widget _buildConfirmationPanel() {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const Text(
              'Konfirmasi Foto',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2340),
              ),
            ),

            // Photo preview
            if (_capturedPhoto != null)
              CircleAvatar(
                radius: 72,
                backgroundImage: FileImage(File(_capturedPhoto!.path)),
              ),

            const Text(
              'Pastikan wajah Anda terlihat jelas dalam lingkaran!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            Row(
              spacing: 12,
              children: [
                // ~:Retry button:~
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1A2340),
                      side: const BorderSide(color: Color(0xFF1A2340)),
                      elevation: 0.5,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _retryPhoto,
                    child: const Text(
                      'Coba Lagi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // ~:Confirm button:~
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0.5,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _confirmPhoto,
                    child: const Text(
                      'Gunakan Foto',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: SlidingUpPanel(
        controller: _panelController,
        minHeight: 0,
        maxHeight: Platform.isIOS
            ? 360
            : 360 + MediaQuery.of(context).padding.bottom,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        backdropEnabled: true,
        backdropColor: Colors.black,
        backdropOpacity: 0.5,
        isDraggable: false,
        panel: _buildConfirmationPanel(),
        body: Scaffold(
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
              onPressed: () => _close(),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              children: [
                // ~:Camera:~
                Expanded(
                  child: _isCameraReady && _cameraController != null
                      ? CameraPreviewWidget(controller: _cameraController!)
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                ),

                // ~:Face Recognition:~
                BlocBuilder<FaceRecognitionBloc, FaceRecognitionState>(
                  builder: (context, state) {
                    return Column(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ~:Status:~
                        switch (state) {
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
                          FaceReadyForCapture() => LivenessInstructionWidget(
                            instruction:
                                'Wajah terdeteksi! Siap mengambil foto.',
                            faceDetected: true,
                            livenessOk: true,
                          ),
                          _ => const SizedBox.shrink(),
                        },

                        // ~:Button:~
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (state is FaceReadyForCapture)
                                  ? Colors.green
                                  : Colors.grey,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () =>
                                _capturePhoto(state is FaceReadyForCapture),
                            icon: Icon(
                              Icons.camera_alt,
                              color: (state is FaceReadyForCapture)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            label: Text(
                              'Ambil Foto',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: (state is FaceReadyForCapture)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
