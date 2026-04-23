import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:sip_sales_clean/domain/repositories/face_recognition_domain.dart';

import '../../domain/entities/face_embedding_entity.dart';
import '../datasources/face_recognition_local_datasource.dart';
import '../datasources/face_recognition_regula_datasource.dart';
import '../models/face_embedding_model.dart';

class FaceRecognitionRepositoryImpl implements FaceRecognitionRepository {
  final FaceRecognitionLocalDatasource _localDatasource;
  final FaceRecognitionRegulaDatasource _regulaDatasource;

  FaceRecognitionRepositoryImpl({
    required FaceRecognitionLocalDatasource localDatasource,
    required FaceRecognitionRegulaDatasource regulaDatasource,
  }) : _localDatasource = localDatasource,
       _regulaDatasource = regulaDatasource;

  /// Must be called before any embedding operations.
  Future<void> initialize() async {
    // await _localDatasource.loadModel();
    await _regulaDatasource.initialize();
  }

  @override
  Future<List<double>> extractEmbedding(img.Image croppedFace) async {
    try {
      return _localDatasource.extractEmbedding(croppedFace);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveReferenceEmbedding(FaceEmbeddingEntity entity) async {
    final model = FaceEmbeddingModel.fromEntity(entity);
    await _localDatasource.saveEmbedding(model);
  }

  @override
  Future<FaceEmbeddingEntity?> getReferenceEmbedding(String userId) async {
    return _localDatasource.getEmbedding(userId);
  }

  @override
  Future<void> deleteReferenceEmbedding(String userId) async {
    await _localDatasource.deleteEmbedding(userId);
  }

  @override
  Future<bool> hasReferenceEmbedding(String userId) async {
    return _localDatasource.hasEmbedding(userId);
  }

  @override
  Future<void> saveReferenceImage(String userId, String base64Image) async {
    await _regulaDatasource.saveReferenceImage(userId, base64Image);
  }

  @override
  Future<String?> getReferenceImage(String userId) async {
    return _regulaDatasource.getReferenceImage(userId);
  }

  @override
  Future<({double score, bool isMatch})> matchWithRegula({
    required String referenceBase64,
    required Uint8List liveImageBytes,
  }) async {
    return _regulaDatasource.matchFaces(
      referenceBase64: referenceBase64,
      liveBytes: liveImageBytes,
    );
  }

  void dispose() {
    _localDatasource.dispose();
  }
}
