import 'package:image/image.dart' as img;
import 'package:sip_sales_clean/domain/repositories/face_recognition_domain.dart';

import '../../domain/entities/face_embedding_entity.dart';
import '../datasources/face_recognition_local_datasource.dart';
import '../models/face_embedding_model.dart';

class FaceRecognitionRepositoryImpl implements FaceRecognitionRepository {
  final FaceRecognitionLocalDatasource _localDatasource;

  FaceRecognitionRepositoryImpl({
    required FaceRecognitionLocalDatasource localDatasource,
  }) : _localDatasource = localDatasource;

  /// Must be called before any embedding operations.
  Future<void> initialize() async {
    await _localDatasource.loadModel();
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

  void dispose() {
    _localDatasource.dispose();
  }
}
