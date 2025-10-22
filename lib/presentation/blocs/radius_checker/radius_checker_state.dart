abstract class RadiusCheckerState {}

class RadiusCheckerInit extends RadiusCheckerState {}

class RadiusCheckerLoading extends RadiusCheckerState {
  final bool isRefresh; // for differentiator between refresh and initial load

  RadiusCheckerLoading({required this.isRefresh});
}

class RadiusCheckerSuccess extends RadiusCheckerState {
  final bool isClose;
  final bool isRefresh; // for differentiator between refresh and initial load
  // final bool isInit;

  RadiusCheckerSuccess({
    required this.isClose,
    required this.isRefresh,
    // required this.isInit,
  });
}

class RadiusCheckerError extends RadiusCheckerState {
  final String message;
  final bool isRefresh; // for differentiator between refresh and initial load
  // final bool isInit;

  RadiusCheckerError({
    required this.message,
    required this.isRefresh,
    // required this.isInit,
  });
}

// ~:Init State:~
class RadiusCheckerInitSuccess extends RadiusCheckerState {
  RadiusCheckerInitSuccess();
}

class RadiusCheckerInitError extends RadiusCheckerState {
  final String message;

  RadiusCheckerInitError({
    required this.message,
  });
}
