class FaceRecognitionConstants {
  FaceRecognitionConstants._();

  // ── Model Configuration ──
  static const String modelAssetPath = 'assets/ai_models/mobile_face_net.tflite';
  static const int inputSize = 112; // MobileFaceNet expects 112x112
  static const int embeddingSize = 192; // MobileFaceNet outputs 192-d vector

  // ── Similarity Threshold ──
  // TUNE THIS with real data. Test 50+ genuine pairs and 50+ impostor pairs.
  // Too high = employees rejected. Too low = spoofing gets through.
  static const double similarityThreshold = 0.6;

  // ── Liveness Thresholds ──
  static const double eyeOpenThreshold = 0.5;
  static const double maxHeadRotationY = 30.0;
  static const double maxHeadRotationZ = 20.0;

  // ── Camera ──
  static const int cameraFps = 15;
  static const double minFaceAreaRatio = 0.15; // face must fill 15%+ of frame
}
