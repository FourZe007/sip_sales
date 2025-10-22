// ...existing code...
import 'package:sip_sales_clean/data/models/coordinator_dashboard.dart';

abstract class ShopCoordinatorState {}

class ShopCoordinatorInitial extends ShopCoordinatorState {}

class CoordinatorDashboardLoading extends ShopCoordinatorState {}

class CoordinatorDashboardLoaded extends ShopCoordinatorState {
  final List<CoordinatorDashboardModel> coordData;

  CoordinatorDashboardLoaded(this.coordData);
}

class CoordinatorDashboardError extends ShopCoordinatorState {
  final String message;

  CoordinatorDashboardError(this.message);
}
