import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

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

    // 2. Detect face to get bounding box — must match the verification path
    final bgraBytes = Uint8List.fromList(
      image.getBytes(order: img.ChannelOrder.bgra),
    );
    final inputImage = InputImage.fromBytes(
      bytes: bgraBytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.bgra8888,
        bytesPerRow: image.width * 4,
      ),
    );

    final faces = await _faceDetector.processImage(inputImage);
    if (faces.isEmpty) {
      throw EnrollmentException('No face detected in the uploaded photo');
    }

    // 3. Crop face — identical to verification preprocessing
    final croppedFace = ImageHelper.cropFace(image, faces.first.boundingBox);

    // 4. Extract embedding from the cropped face (not the full photo)
    final embedding = await _repository.extractEmbedding(croppedFace);
    if (embedding.isEmpty) {
      throw EnrollmentException('Failed to extract face embedding');
    }

    // 4. Store
    final entity = FaceEmbeddingEntity(
      userId: userId,
      embedding: embedding,
      enrolledAt: DateTime.now(),
    );

    // await _repository.saveReferenceEmbedding(entity);
    await _repository.saveReferenceImage(userId, base64Image);
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
