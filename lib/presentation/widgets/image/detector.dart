import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
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

  static final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  static Future<bool> hasFace(XFile? image) async {
    final sensorOrientation = camera.sensorOrientation;
    final rotation = _getImageRotation(sensorOrientation);
    if (rotation == null) return false;

    final inputImage = await _getInputImage(image, rotation);
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

  static InputImageRotation? _getImageRotation(int sensorOrientation) {
    if (Platform.isIOS) {
      return InputImageRotationValue.fromRawValue(sensorOrientation);
    }
    if (Platform.isAndroid) {
      final rotationCompensation = _getRotationCompensation(sensorOrientation);
      return InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    return null;
  }

  static int _getRotationCompensation(int sensorOrientation) {
    final deviceOrientation = controller.value.deviceOrientation;

    final rotationCompensation = _orientations[deviceOrientation]!;

    return camera.lensDirection == CameraLensDirection.front
        ? (sensorOrientation + rotationCompensation) % 360
        : (sensorOrientation - rotationCompensation + 360) % 360;
  }

  static Future<InputImage?> _getInputImage(
    XFile? image,
    InputImageRotation rotation,
  ) async {
    if (image == null) return null;

    final codec = await ui.instantiateImageCodec(await image.readAsBytes());
    final frameInfo = await codec.getNextFrame();

    return InputImage.fromBytes(
      bytes: await image.readAsBytes(),
      metadata: InputImageMetadata(
        size: Size(
          frameInfo.image.width.toDouble(),
          frameInfo.image.height.toDouble(),
        ),
        rotation: rotation,
        format: Platform.isIOS
            ? InputImageFormat.bgra8888
            : InputImageFormat.nv21,
        bytesPerRow: 0,
      ),
    );
  }
}
