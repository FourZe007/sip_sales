import 'package:sip_sales/global/enum.dart';
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

class UpdateFollowupDashboardStatusInitial
    extends UpdateFollowupDashboardState {
  final FollowUpStatus status;

  UpdateFollowupDashboardStatusInitial() : status = FollowUpStatus.values.first;
}

class UpdateFollowupDashboardStatusSucceed
    extends UpdateFollowupDashboardState {
  final FollowUpStatus status;

  UpdateFollowupDashboardStatusSucceed(this.status);
}

class UpdateFollowupDashboardStatusFailed extends UpdateFollowupDashboardState {
  final String message;

  UpdateFollowupDashboardStatusFailed(this.message);
}

// ~:Save Followup Data:~
class SaveFollowupLoading extends UpdateFollowupDashboardState {}

class SaveFollowupSucceed extends UpdateFollowupDashboardState {
  final String message;

  SaveFollowupSucceed(this.message);
}

class SaveFollowupFailed extends UpdateFollowupDashboardState {
  final String message;

  SaveFollowupFailed(this.message);
}
