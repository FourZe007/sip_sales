import 'dart:developer';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
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

    // 2. Detect face — we need InputImage, but since we have raw bytes,
    //    we encode to PNG and use InputImage.fromFilePath or fromBytes.
    //    For enrollment, we work with the decoded img.Image directly
    //    and extract embedding without ML Kit (since we have the full image).
    //
    //    NOTE: For enrollment from a stored image, we skip ML Kit detection
    //    and assume the uploaded photo is a clear face photo.
    //    If you want stricter enrollment, add ML Kit validation here too.

    // 3. Extract embedding
    final embedding = await _repository.extractEmbedding(image);
    if (embedding.isEmpty) {
      throw EnrollmentException('Failed to extract face embedding');
    }

    // 4. Store
    final entity = FaceEmbeddingEntity(
      userId: userId,
      embedding: embedding,
      enrolledAt: DateTime.now(),
    );

    await _repository.saveReferenceEmbedding(entity);
    log('Image Reference saved');

    return entity;
  }
}

class EnrollmentException implements Exception {
  final String message;
  EnrollmentException(this.message);

  @override
  String toString() => 'EnrollmentException: $message';
}
