// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image/image.dart' as img;
import 'package:sip_sales_clean/core/constant/face_recognition_constants.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../core/helpers/image_helper.dart';
import '../models/face_embedding_model.dart';

class FaceRecognitionLocalDatasource {
  Interpreter? _interpreter;
  final FlutterSecureStorage _storage;

  static const String _embeddingKeyPrefix = 'face_embedding_';

  FaceRecognitionLocalDatasource({required FlutterSecureStorage storage})
    : _storage = storage;

  // ── TFLite Model ──

  Future<void> loadModel() async {
    _interpreter ??= await Interpreter.fromAsset(
      FaceRecognitionConstants.modelAssetPath,
    );
  }

  /// Runs the face embedding model on a cropped, preprocessed face image.
  /// Returns a normalized embedding vector.
  List<double> extractEmbedding(img.Image croppedFace) {
    if (_interpreter == null) {
      throw StateError(
        'TFLite interpreter not loaded. Call loadModel() first.',
      );
    }

    final input = ImageHelper.preprocessForModel(
      croppedFace,
      FaceRecognitionConstants.inputSize,
    );
    log('extractEmbedding input: ${input.isEmpty}');

    final output = List.generate(
      1,
      (_) => List.filled(FaceRecognitionConstants.embeddingSize, 0.0),
    );
    log('extractEmbedding output: ${output.isEmpty}, ${output.length}');

    _interpreter!.run(input, output);

    // L2-normalize the embedding for cosine similarity
    final raw = output[0];
    final norm = _l2Norm(raw);
    if (norm == 0) return raw;
    log('Norm is not equal to 0');

    return raw.map((v) => v / norm).toList();
  }

  double _l2Norm(List<double> vector) {
    double sum = 0;
    for (final v in vector) {
      sum += v * v;
    }
    return sum > 0 ? _sqrt(sum) : 0;
  }

  double _sqrt(double value) {
    // Newton's method — avoids dart:math import conflict with image package
    double x = value;
    double y = (x + 1) / 2;
    while (y < x) {
      x = y;
      y = (x + value / x) / 2;
    }
    return x;
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }

  // ── Local Cache (FlutterSecureStorage) ──

  Future<void> saveEmbedding(FaceEmbeddingModel model) async {
    await _storage.write(
      key: '$_embeddingKeyPrefix${model.userId}',
      value: model.toJsonString(),
    );
  }

  Future<FaceEmbeddingModel?> getEmbedding(String userId) async {
    final json = await _storage.read(key: '$_embeddingKeyPrefix$userId');
    if (json == null) return null;
    return FaceEmbeddingModel.fromJsonString(json);
  }

  Future<void> deleteEmbedding(String userId) async {
    await _storage.delete(key: '$_embeddingKeyPrefix$userId');
  }

  Future<bool> hasEmbedding(String userId) async {
    return _storage.containsKey(key: '$_embeddingKeyPrefix$userId');
  }
}
