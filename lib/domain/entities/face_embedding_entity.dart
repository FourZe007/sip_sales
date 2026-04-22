class FaceEmbeddingEntity {
  final String userId;
  final List<double> embedding;
  final DateTime enrolledAt;

  const FaceEmbeddingEntity({
    required this.userId,
    required this.embedding,
    required this.enrolledAt,
  });

  bool get isValid => embedding.isNotEmpty;
}
