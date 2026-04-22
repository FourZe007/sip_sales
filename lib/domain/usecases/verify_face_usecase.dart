import 'package:sip_sales_clean/core/constant/face_recognition_constants.dart';
import 'package:sip_sales_clean/domain/repositories/face_recognition_domain.dart';

import '../../core/helpers/image_helper.dart';
import 'package:image/image.dart' as img;

enum VerificationResult {
  match,
  noMatch,
  noReferenceFound,
  extractionFailed,
}

class VerifyFaceUseCase {
  final FaceRecognitionRepository _repository;

  VerifyFaceUseCase({required FaceRecognitionRepository repository})
    : _repository = repository;

  /// Compares a live cropped face against the stored reference embedding.
  /// Returns [VerificationResult] and the similarity score.
  Future<({VerificationResult result, double score})> call({
    required String userId,
    // required String storedImage,
    required img.Image croppedFace,
  }) async {
    // 1. Get stored reference
    final reference = await _repository.getReferenceEmbedding(userId);
    // ask claude, what if the reference directly uses the stored image from LoginBloc status
    if (reference == null) {
      return (result: VerificationResult.noReferenceFound, score: 0.0);
    }

    // 2. Extract embedding from live capture
    final liveEmbedding = await _repository.extractEmbedding(croppedFace);
    if (liveEmbedding.isEmpty) {
      return (result: VerificationResult.extractionFailed, score: 0.0);
    }

    // 3. Compare
    final score = ImageHelper.cosineSimilarity(
      liveEmbedding,
      reference.embedding,
    );

    final isMatch = score >= FaceRecognitionConstants.similarityThreshold;

    return (
      result: isMatch ? VerificationResult.match : VerificationResult.noMatch,
      score: score,
    );
  }
}
