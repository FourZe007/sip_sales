import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales_clean/data/datasources/face_recognition_local_datasource.dart';
import 'package:sip_sales_clean/data/repositories/face_recognition_data.dart';
import 'package:sip_sales_clean/domain/usecases/enroll_face_usecase.dart';
import 'package:sip_sales_clean/domain/usecases/verify_face_usecase.dart';
import 'package:sip_sales_clean/presentation/blocs/face_recognition_bloc.dart';

/// Holds all face recognition dependencies.
/// Initialize once in main(), pass around or access globally.
class FaceRecognitionDependencies {
  static FaceRecognitionDependencies? _instance;
  static FaceRecognitionDependencies get instance => _instance!;

  final FaceRecognitionLocalDatasource datasource;
  final FaceRecognitionRepositoryImpl repository;
  final FaceDetector faceDetector;
  final EnrollFaceUseCase enrollFaceUseCase;
  final VerifyFaceUseCase verifyFaceUseCase;

  FaceRecognitionDependencies._({
    required this.datasource,
    required this.repository,
    required this.faceDetector,
    required this.enrollFaceUseCase,
    required this.verifyFaceUseCase,
  });

  /// Call this once at app startup. It loads the TFLite model.
  static Future<FaceRecognitionDependencies> initialize() async {
    // 1. SharedPreferences (you might already have this — reuse it)
    final prefs = await SharedPreferences.getInstance();

    // 2. Datasource — owns the TFLite interpreter and local cache
    final datasource = FaceRecognitionLocalDatasource(prefs: prefs);

    // 3. Repository
    final repository = FaceRecognitionRepositoryImpl(
      localDatasource: datasource,
    );

    // Load the TFLite model into memory — do this at startup, not at verification time
    await repository.initialize();

    // 4. ML Kit Face Detector — shared across enrollment and verification
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true, // Required for liveness (eye open, smile)
        enableTracking: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );

    // 5. Use cases
    final enrollFaceUseCase = EnrollFaceUseCase(
      repository: repository,
      faceDetector: faceDetector,
    );

    final verifyFaceUseCase = VerifyFaceUseCase(
      repository: repository,
    );

    _instance = FaceRecognitionDependencies._(
      datasource: datasource,
      repository: repository,
      faceDetector: faceDetector,
      enrollFaceUseCase: enrollFaceUseCase,
      verifyFaceUseCase: verifyFaceUseCase,
    );
    return _instance!;
  }

  /// Creates a new BLoC instance. Call this each time you need a fresh BLoC
  /// (e.g., per screen navigation). Do NOT reuse a closed BLoC.
  FaceRecognitionBloc createBloc() {
    return FaceRecognitionBloc(
      enrollFaceUseCase: enrollFaceUseCase,
      verifyFaceUseCase: verifyFaceUseCase,
      faceDetector: faceDetector,
    );
  }

  void dispose() {
    repository.dispose();
    faceDetector.close();
  }
}
