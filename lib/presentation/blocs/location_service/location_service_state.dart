abstract class LocationServiceState {}

class LocationServiceInit extends LocationServiceState {}

class LocationServiceLoading extends LocationServiceState {}

class LocationServiceSuccess extends LocationServiceState {
  LocationServiceSuccess();
}

class LocationServiceFailed extends LocationServiceState {
  final String message;

  LocationServiceFailed(this.message);
}
