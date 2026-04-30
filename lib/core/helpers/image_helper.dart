import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

class ImageHelper {
  ImageHelper._();

  /// Converts a CameraImage (YUV420/NV21) to img.Image.
  /// This is the most error-prone step. Test on both Android and iOS.
  /// Android typically gives NV21, iOS gives BGRA8888.
  static img.Image? convertCameraImage(CameraImage cameraImage) {
    dev.log(
      'Image Format: ${cameraImage.format.group}, planes: ${cameraImage.planes.length}',
    );
    try {
      if (cameraImage.format.group == ImageFormatGroup.yuv420) {
        dev.log('cameraImage format is YUV420');
        return _convertYUV420(cameraImage);
      } else if (cameraImage.format.group == ImageFormatGroup.nv21) {
        dev.log('cameraImage format is NV21');
        return _convertNV21(cameraImage);
      } else if (cameraImage.format.group == ImageFormatGroup.bgra8888) {
        dev.log('cameraImage format is BGRA8888');
        return _convertBGRA8888(cameraImage);
      }
      dev.log('Unsupported image format: ${cameraImage.format.group}');
      return null;
    } catch (e, st) {
      dev.log('convertCameraImage error: $e', stackTrace: st);
      return null;
    }
  }

  static img.Image _convertYUV420(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel!;
    final yPlane = image.planes[0].bytes;
    final uPlane = image.planes[1].bytes;
    final vPlane = image.planes[2].bytes;

    final result = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex = uvPixelStride * (x ~/ 2) + uvRowStride * (y ~/ 2);
        final int yValue = yPlane[y * image.planes[0].bytesPerRow + x];
        final int uValue = uPlane[uvIndex];
        final int vValue = vPlane[uvIndex];

        int r = (yValue + 1.370705 * (vValue - 128)).round().clamp(0, 255);
        int g = (yValue - 0.337633 * (uValue - 128) - 0.698001 * (vValue - 128))
            .round()
            .clamp(0, 255);
        int b = (yValue + 1.732446 * (uValue - 128)).round().clamp(0, 255);

        result.setPixelRgba(x, y, r, g, b, 255);
      }
    }
    return result;
  }

  static img.Image _convertNV21(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final yPlane = image.planes[0].bytes;
    final int yStride = image.planes[0].bytesPerRow;

    // Some Android devices (e.g. Android 8 with CameraX) pack Y + VU into a
    // single plane. Others (Camera2 on newer Android) use two separate planes.
    final Uint8List vuPlane;
    final int uvRowStride;
    final int uvPixelStride;
    final int vuOffset;

    dev.log('Image planes length: ${image.planes.length}');
    if (image.planes.length >= 2) {
      vuPlane = image.planes[1].bytes;
      uvRowStride = image.planes[1].bytesPerRow;
      uvPixelStride = image.planes[1].bytesPerPixel ?? 2;
      vuOffset = 0;
    } else {
      // Single-plane: VU data follows Y data at offset yStride * height
      vuPlane = yPlane;
      uvRowStride = yStride;
      uvPixelStride = 2;
      vuOffset = yStride * height;
    }

    final result = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int yValue = yPlane[y * yStride + x];
        final int uvIndex =
            vuOffset + (y ~/ 2) * uvRowStride + (x ~/ 2) * uvPixelStride;
        final int vValue = vuPlane[uvIndex]; // V first in NV21
        final int uValue = vuPlane[uvIndex + 1]; // U second in NV21

        int r = (yValue + 1.370705 * (vValue - 128)).round().clamp(0, 255);
        int g = (yValue - 0.337633 * (uValue - 128) - 0.698001 * (vValue - 128))
            .round()
            .clamp(0, 255);
        int b = (yValue + 1.732446 * (uValue - 128)).round().clamp(0, 255);

        result.setPixelRgba(x, y, r, g, b, 255);
      }
    }
    return result;
  }

  static img.Image _convertBGRA8888(CameraImage image) {
    final plane = image.planes[0];
    final width = image.width;
    final height = image.height;
    final bytesPerRow = plane.bytesPerRow;
    final src = plane.bytes;
    final expectedRow = width * 4;

    dev.log(
      'BGRA8888 convert: width=$width height=$height '
      'bytesPerRow=$bytesPerRow expectedRow=$expectedRow '
      'srcLength=${src.lengthInBytes} srcOffset=${src.offsetInBytes}',
    );

    // iOS BGRA frames are usually padded so bytesPerRow > width * 4 for
    // 16-byte stride alignment, and `src` is often a view into a larger
    // buffer with a non-zero offset. We must strip the row padding and
    // copy into a fresh, tightly-packed Uint8List so the image package
    // reads the correct bytes.
    final packed = Uint8List(expectedRow * height);
    if (bytesPerRow == expectedRow) {
      packed.setRange(0, packed.length, src);
    } else {
      for (var row = 0; row < height; row++) {
        final srcStart = row * bytesPerRow;
        final dstStart = row * expectedRow;
        packed.setRange(dstStart, dstStart + expectedRow, src, srcStart);
      }
    }

    return img.Image.fromBytes(
      width: width,
      height: height,
      bytes: packed.buffer,
      order: img.ChannelOrder.bgra,
    );
  }

  /// Crops the face region from the full image using the ML Kit bounding box.
  /// Adds padding around the face for better embedding quality.
  static img.Image cropFace(img.Image fullImage, ui.Rect boundingBox) {
    // Add 20% padding around the face
    final double padding = 0.2;
    final int padX = (boundingBox.width * padding).toInt();
    final int padY = (boundingBox.height * padding).toInt();

    final int x = (boundingBox.left - padX)
        .clamp(0, fullImage.width - 1)
        .toInt();
    final int y = (boundingBox.top - padY)
        .clamp(0, fullImage.height - 1)
        .toInt();
    final int w = (boundingBox.width + padX * 2)
        .clamp(1, fullImage.width - x)
        .toInt();
    final int h = (boundingBox.height + padY * 2)
        .clamp(1, fullImage.height - y)
        .toInt();

    return img.copyCrop(fullImage, x: x, y: y, width: w, height: h);
  }

  /// Preprocesses a cropped face image for MobileFaceNet input.
  /// Returns a [1, 112, 112, 3] tensor normalized to [-1, 1].
  static List<List<List<List<double>>>> preprocessForModel(
    img.Image croppedFace,
    int inputSize,
  ) {
    final resized = img.copyResize(
      croppedFace,
      width: inputSize,
      height: inputSize,
    );

    return List.generate(1, (_) {
      return List.generate(inputSize, (y) {
        return List.generate(inputSize, (x) {
          final pixel = resized.getPixel(x, y);
          return [
            (pixel.r / 255.0 - 0.5) / 0.5, // normalize to [-1, 1]
            (pixel.g / 255.0 - 0.5) / 0.5,
            (pixel.b / 255.0 - 0.5) / 0.5,
          ];
        });
      });
    });
  }

  /// Cosine similarity between two embedding vectors.
  /// Returns value between -1 and 1. Higher = more similar.
  static double cosineSimilarity(List<double> a, List<double> b) {
    assert(a.length == b.length, 'Embedding dimensions must match');

    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }

    if (normA == 0 || normB == 0) return 0.0;

    return dotProduct / (sqrt(normA) * sqrt(normB));
  }

  /// Decodes a base64 string to an img.Image.
  static img.Image? decodeBase64Image(String base64String) {
    try {
      final bytes = Uint8List.fromList(
        // Strip data URI prefix if present
        base64String.contains(',')
            ? base64Decode(base64String.split(',').last)
            : base64Decode(base64String),
      );
      return img.decodeImage(bytes);
    } catch (e) {
      return null;
    }
  }
}

Uint8List base64Decode(String input) {
  // Use dart:convert's base64Decode
  return Uint8List.fromList(
    const Base64Decoder().convert(input),
  );
}
