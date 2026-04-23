import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../entities/face_embedding_entity.dart';

abstract class FaceRecognitionRepository {
  /// Extract embedding vector from a face image.
  Future<List<double>> extractEmbedding(img.Image croppedFace);

  /// Save the reference embedding for a user.
  Future<void> saveReferenceEmbedding(FaceEmbeddingEntity entity);

  /// Load the cached reference embedding for a user.
  Future<FaceEmbeddingEntity?> getReferenceEmbedding(String userId);

  /// Delete cached reference embedding.
  Future<void> deleteReferenceEmbedding(String userId);

  /// Check if a reference embedding exists for the user.
  Future<bool> hasReferenceEmbedding(String userId);

  // ── Regula methods ──

  /// Save the raw reference photo (base64) for Regula matching.
  Future<void> saveReferenceImage(String userId, String base64Image);

  /// Retrieve the raw reference photo (base64) for Regula matching.
  Future<String?> getReferenceImage(String userId);

  /// Match two face images using the Regula SDK.
  Future<({double score, bool isMatch})> matchWithRegula({
    required String referenceBase64,
    required Uint8List liveImageBytes,
  });
}
