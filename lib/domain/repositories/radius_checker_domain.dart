abstract class RadiusCheckerRepo {
  Future<Map<String, dynamic>> checkRadius(
    double userLat,
    double userLng,
    double currentLat,
    double currentLng,
  );
}
