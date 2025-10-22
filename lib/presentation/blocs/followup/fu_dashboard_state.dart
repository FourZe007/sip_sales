import 'package:sip_sales_clean/data/models/fu_dashboard.dart';

abstract class FollowupDashboardState {}

// ~:Not Followed Up:~
class FollowupDashboardInitial extends FollowupDashboardState {}

class FollowupDashboardLoading extends FollowupDashboardState {}

class FollowupDashboardLoaded extends FollowupDashboardState {
  final List<FollowUpDashboardModel> fuData;

  FollowupDashboardLoaded(this.fuData);
}

class FollowupDashboardError extends FollowupDashboardState {
  final String message;
  FollowupDashboardError(this.message);
}

// ~:Deal:~
class FollowupDealDashboardInitial extends FollowupDashboardState {}

class FollowupDealDashboardLoading extends FollowupDashboardState {}

class FollowupDealDashboardLoaded extends FollowupDashboardState {
  final List<FollowUpDealDashboardModel> dealData;

  FollowupDealDashboardLoaded(this.dealData);
}

class FollowupDealDashboardError extends FollowupDashboardState {
  final String message;
  FollowupDealDashboardError(this.message);
}
