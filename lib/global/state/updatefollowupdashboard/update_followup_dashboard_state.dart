import 'package:sip_sales/global/model.dart';

abstract class UpdateFollowupDashboardState {}

class UpdateFollowupDashboardInitial extends UpdateFollowupDashboardState {}

class UpdateFollowupDashboardLoading extends UpdateFollowupDashboardState {}

class UpdateFollowupDashboardLoaded extends UpdateFollowupDashboardState {
  final List<UpdateFollowUpDashboardModel> updateFollowupData;

  UpdateFollowupDashboardLoaded(this.updateFollowupData);
}

class UpdateFollowupDashboardError extends UpdateFollowupDashboardState {
  final String message;
  UpdateFollowupDashboardError(this.message);
}
