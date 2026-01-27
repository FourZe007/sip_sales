import 'dart:io';

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class ImageDetector {
  static final CameraDescription camera = CameraDescription(
    name: 'Camera 1',
    lensDirection: CameraLensDirection.back,
    sensorOrientation: 90,
  );
  static final controller = CameraController(
    camera,
    ResolutionPreset.max,
    enableAudio: false,
    imageFormatGroup: Platform.isAndroid
        ? ImageFormatGroup
              .nv21 // for Android
        : ImageFormatGroup.bgra8888, // for iOS
  );

  static Future<bool> hasFace(XFile? image) async {
    final inputImage = await _getInputImage(image);
    if (inputImage == null) return false;

    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        enableLandmarks: true,
      ),
    );

    final faces = await faceDetector.processImage(inputImage);

    return faces.isNotEmpty;
  }

  static Future<InputImage?> _getInputImage(XFile? image) async {
    if (image == null) return null;

    return InputImage.fromFilePath(image.path);
  }
}
