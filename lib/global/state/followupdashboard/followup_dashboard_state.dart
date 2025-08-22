// ...existing code...
import 'package:sip_sales/global/model.dart';

abstract class FollowupDashboardState {}

// ~:Not Followed Up:~
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

// ~:Deal:~
class FollowupDealDashboardInitial extends FollowupDashboardState {}

class FollowupDealDashboardLoading extends FollowupDashboardState {}

class FollowupDealDashboardLoaded extends FollowupDashboardState {
  final List<FollowUpDealDashboardModel> salesData;

  FollowupDealDashboardLoaded(this.salesData);
}

class FollowupDealDashboardError extends FollowupDashboardState {
  final String message;
  FollowupDealDashboardError(this.message);
}
