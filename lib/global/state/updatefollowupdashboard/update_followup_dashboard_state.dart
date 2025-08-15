import 'package:sip_sales/global/enum.dart';
import 'package:sip_sales/global/model.dart';

abstract class UpdateFollowupDashboardState {}

class UpdateFollowupDashboardInitial extends UpdateFollowupDashboardState {}

// ~:Update Follow Up Date:~
// ~:Delete later:~
class UpdateFollowUpDateSuccess extends UpdateFollowupDashboardState {
  final UpdateFollowUpDashboardModel data;

  UpdateFollowUpDateSuccess(this.data);
}

class UpdateFollowUpDateFailed extends UpdateFollowupDashboardState {
  final String message;

  UpdateFollowUpDateFailed(this.message);
}

// ~:Update Next Follow Up Date:~
// ~:Delete later:~
class UpdateNextFollowUpDateSuccess extends UpdateFollowupDashboardState {
  final UpdateFollowUpDashboardModel data;

  UpdateNextFollowUpDateSuccess(this.data);
}

class UpdateNextFollowUpDateFailed extends UpdateFollowupDashboardState {
  final String message;

  UpdateNextFollowUpDateFailed(this.message);
}

class UpdateFollowupDashboardLoading extends UpdateFollowupDashboardState {}

class UpdateFollowupDashboardLoaded extends UpdateFollowupDashboardState {
  final List<UpdateFollowUpDashboardModel> updateFollowupData;

  UpdateFollowupDashboardLoaded(this.updateFollowupData);
}

class UpdateFollowupDashboardError extends UpdateFollowupDashboardState {
  final String message;
  UpdateFollowupDashboardError(this.message);
}

// ~:Update Followup Results:~
class UpdateFollowupDashboardResultsInitial
    extends UpdateFollowupDashboardState {
  final List<FollowUpResults> results;

  UpdateFollowupDashboardResultsInitial()
      : results = List.generate(
          FollowUpResults.values.length,
          (index) => FollowUpResults.pending,
        );
}

class UpdateFollowupDashboardResultsSucceed
    extends UpdateFollowupDashboardState {
  final List<FollowUpResults> results;

  UpdateFollowupDashboardResultsSucceed(
      {required List<FollowUpResults> oldResults,
      required FollowUpResults newResult,
      required int index})
      : results = List.from(oldResults)..[index] = newResult;
}

class UpdateFollowupDashboardResultsFailed
    extends UpdateFollowupDashboardState {
  final String message;

  UpdateFollowupDashboardResultsFailed(this.message);
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
