import 'dart:developer';
import 'dart:io';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:sip_sales_clean/domain/repositories/face_recognition_domain.dart';

import '../../core/helpers/image_helper.dart';
import '../entities/face_embedding_entity.dart';

class EnrollFaceUseCase {
  final FaceRecognitionRepository _repository;
  final FaceDetector _faceDetector;

  EnrollFaceUseCase({
    required FaceRecognitionRepository repository,
    required FaceDetector faceDetector,
  }) : _repository = repository,
       _faceDetector = faceDetector;

  /// Enrolls a face from a base64 image string (the user's uploaded photo).
  /// Returns the entity on success, or throws on failure.
  Future<FaceEmbeddingEntity> call({
    required String userId,
    required String base64Image,
  }) async {
    // 1. Decode base64 to image
    final image = ImageHelper.decodeBase64Image(base64Image);
    if (image == null) {
      throw EnrollmentException('Failed to decode image from base64');
    }

    // 2. Detect face — encode to JPEG temp file so ML Kit handles the format
    //    natively on both Android and iOS (avoids bgra8888 Android rejection).
    final tempFile = File(
      '${Directory.systemTemp.path}/enroll_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await tempFile.writeAsBytes(img.encodeJpg(image));

    final List<Face> faces;
    try {
      faces = await _faceDetector.processImage(
        InputImage.fromFilePath(tempFile.path),
      );
    } finally {
      await tempFile.delete();
    }
    if (faces.isEmpty) {
      throw EnrollmentException('No face detected in the uploaded photo');
    }

    // 3. Save reference image for Regula matching
    await _repository.saveReferenceImage(userId, base64Image);
    log('Image Reference saved');

    return FaceEmbeddingEntity(
      userId: userId,
      embedding: const [],
      enrolledAt: DateTime.now(),
    );
  }
}

class EnrollmentException implements Exception {
  final String message;
  EnrollmentException(this.message);

  @override
  String toString() => 'EnrollmentException: $message';
}
