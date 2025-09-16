// ...existing code...
import 'package:sip_sales/global/model.dart';

abstract class CoordinatorDashboardState {}

class CoordinatorDashboardInitial extends CoordinatorDashboardState {}

class CoordinatorDashboardLoading extends CoordinatorDashboardState {}

class CoordinatorDashboardLoaded extends CoordinatorDashboardState {
  final List<CoordinatorDashboardModel> coordData;

  CoordinatorDashboardLoaded(this.coordData);
}

class CoordinatorDashboardError extends CoordinatorDashboardState {
  final String message;

  CoordinatorDashboardError(this.message);
}
