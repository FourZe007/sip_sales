abstract class RadiusCheckerEvent {}

class RadiusCheckerEventCheck extends RadiusCheckerEvent {
  final double userLat;
  final double userLng;
  final double currentLat;
  final double currentLng;
  final bool isRefresh;
  final bool isInit;

  RadiusCheckerEventCheck({
    required this.userLat,
    required this.userLng,
    required this.currentLat,
    required this.currentLng,
    this.isRefresh = false,
    this.isInit = false,
  });
}

class RadiusCheckerInitEvent extends RadiusCheckerEvent {
  final double userLat;
  final double userLng;
  final double currentLat;
  final double currentLng;
  final bool isRefresh;

  RadiusCheckerInitEvent({
    required this.userLat,
    required this.userLng,
    required this.currentLat,
    required this.currentLng,
    this.isRefresh = false,
  });
}
