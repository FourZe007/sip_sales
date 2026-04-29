import 'dart:developer';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:sip_sales_clean/core/constant/face_recognition_constants.dart';
import 'package:sip_sales_clean/domain/repositories/face_recognition_domain.dart';

import '../../core/helpers/image_helper.dart';

enum VerificationResult {
  match,
  noMatch,
  noReferenceFound,
  extractionFailed,
}

class VerifyFaceUseCase {
  final FaceRecognitionRepository _repository;
  // final FaceRecognitionRegulaDatasource _regulaRepository;

  VerifyFaceUseCase({
    required FaceRecognitionRepository repository,
    // required FaceRecognitionRegulaDatasource regulaRepository,
  }) : _repository = repository;
  //  _regulaRepository = regulaRepository;

  /// Compares a live cropped face against the stored reference.
  /// [method] selects TFLite cosine similarity (default) or Regula SDK.
  Future<({VerificationResult result, double score})> call({
    required String userId,
    required img.Image croppedFace,
    VerificationMethod method = VerificationMethod.regula,
  }) async {
    if (method == VerificationMethod.regula) {
      return _verifyWithRegula(userId, croppedFace);
    }
    return _verifyWithTflite(userId, croppedFace);
  }

  // ── TFLite path (Method 1 — original, unchanged) ──

  Future<({VerificationResult result, double score})> _verifyWithTflite(
    String userId,
    img.Image croppedFace,
  ) async {
    final reference = await _repository.getReferenceEmbedding(userId);
    if (reference == null) {
      return (result: VerificationResult.noReferenceFound, score: 0.0);
    }
    final liveEmbedding = await _repository.extractEmbedding(croppedFace);
    if (liveEmbedding.isEmpty) {
      return (result: VerificationResult.extractionFailed, score: 0.0);
    }
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

  // ── Regula path (Method 2) ──

  Future<({VerificationResult result, double score})> _verifyWithRegula(
    String userId,
    img.Image croppedFace,
  ) async {
    final refBase64 = await _repository.getReferenceImage(userId);
    if (refBase64 == null) {
      log('Image reference is empty or null');
      return (result: VerificationResult.noReferenceFound, score: 0.0);
    }
    final liveBytes = Uint8List.fromList(img.encodeJpg(croppedFace));
    final (:score, :isMatch) = await _repository.matchWithRegula(
      referenceBase64: refBase64,
      liveImageBytes: liveBytes,
    );
    return (
      result: isMatch ? VerificationResult.match : VerificationResult.noMatch,
      score: score,
    );
  }
}
