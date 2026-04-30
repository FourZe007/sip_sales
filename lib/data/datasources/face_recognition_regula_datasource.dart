import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sip_sales_clean/core/constant/face_recognition_constants.dart';

class FaceRecognitionRegulaDatasource {
  final FlutterSecureStorage _storage;
  static const String _keyPrefix = 'face_regula_ref_';

  bool _isAvailable = false;

  /// Whether the Regula SDK initialized successfully.
  bool get isAvailable => _isAvailable;

  FaceRecognitionRegulaDatasource({required FlutterSecureStorage storage})
      : _storage = storage;

  /// Initialize the Regula SDK. Safe to call more than once: subsequent calls
  /// no-op when the SDK is already up. A "Core already running" error is also
  /// treated as success — this happens after a Flutter hot restart, where the
  /// Dart VM resets but the native Regula process keeps running.
  Future<void> initialize() async {
    if (_isAvailable) return;
    try {
      final (success, error) = await FaceSDK.instance.initialize();
      if (success) {
        _isAvailable = true;
        log('Regula SDK initialized successfully');
        return;
      }
      final message = error?.message ?? '';
      if (message.toLowerCase().contains('already running')) {
        _isAvailable = true;
        log('Regula SDK already running — reusing existing native instance');
        return;
      }
      log('Regula SDK init failed: $message');
    } catch (e) {
      log('Regula SDK init exception: $e');
    }
  }

  /// Store the profile photo base64 as the reference for Regula matching.
  Future<void> saveReferenceImage(String userId, String base64Image) async {
    await _storage.write(key: '$_keyPrefix$userId', value: base64Image);
  }

  /// Retrieve the stored reference photo base64, or null if not enrolled.
  Future<String?> getReferenceImage(String userId) async {
    return _storage.read(key: '$_keyPrefix$userId');
  }

  /// Compare two face images using the Regula SDK.
  /// [referenceBase64] — stored profile photo (base64 string).
  /// [liveBytes] — JPEG bytes of the current live face capture.
  Future<({double score, bool isMatch})> matchFaces({
    required String referenceBase64,
    required Uint8List liveBytes,
  }) async {
    if (!_isAvailable) {
      log('Regula SDK not available — skipping match');
      return (score: 0.0, isMatch: false);
    }

    try {
      final refBytes = Uint8List.fromList(base64Decode(referenceBase64));
      final image1 = MatchFacesImage(refBytes, ImageType.EXTERNAL);
      final image2 = MatchFacesImage(liveBytes, ImageType.LIVE);

      final response = await FaceSDK.instance.matchFaces(
        MatchFacesRequest([image1, image2]),
      );

      if (response.error != null || response.results.isEmpty) {
        log('Regula matchFaces error: ${response.error?.message}');
        return (score: 0.0, isMatch: false);
      }

      final score = response.results.first.similarity;
      log(
        'Regula matchFaces: score=$score '
        'threshold=${FaceRecognitionConstants.regulaSimilarityThreshold} '
        'liveBytes=${liveBytes.length} refBytes=${refBytes.length}',
      );
      return (
        score: score,
        isMatch: score >= FaceRecognitionConstants.regulaSimilarityThreshold,
      );
    } catch (e) {
      log('Regula matchFaces exception: $e');
      return (score: 0.0, isMatch: false);
    }
  }
}
