// ...existing code...
import 'package:sip_sales/global/model.dart';

abstract class FollowupDashboardState {}

class FollowupDashboardInitial extends FollowupDashboardState {}

class FollowupDashboardLoading extends FollowupDashboardState {}

class FollowupDashboardLoaded extends FollowupDashboardState {
  final List<FollowUpDashboardModel> salesData;

  FollowupDashboardLoaded(this.salesData);
}

class FollowupDashboardError extends FollowupDashboardState {
  final String message;
  FollowupDashboardError(this.message);
}
