import 'dart:convert';

import '../../domain/entities/face_embedding_entity.dart';

class FaceEmbeddingModel extends FaceEmbeddingEntity {
  const FaceEmbeddingModel({
    required super.userId,
    required super.embedding,
    required super.enrolledAt,
  });

  factory FaceEmbeddingModel.fromEntity(FaceEmbeddingEntity entity) {
    return FaceEmbeddingModel(
      userId: entity.userId,
      embedding: entity.embedding,
      enrolledAt: entity.enrolledAt,
    );
  }

  /// Serialize to JSON string for local storage.
  String toJsonString() {
    return jsonEncode({
      'userId': userId,
      'embedding': embedding,
      'enrolledAt': enrolledAt.toIso8601String(),
    });
  }

  /// Deserialize from JSON string.
  factory FaceEmbeddingModel.fromJsonString(String jsonString) {
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return FaceEmbeddingModel(
      userId: map['userId'] as String,
      embedding: (map['embedding'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      enrolledAt: DateTime.parse(map['enrolledAt'] as String),
    );
  }
}
