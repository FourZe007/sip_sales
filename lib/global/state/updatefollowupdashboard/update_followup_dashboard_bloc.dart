import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/model.dart';
import 'update_followup_dashboard_event.dart';
import 'update_followup_dashboard_state.dart';

class UpdateFollowupDashboardBloc
    extends Bloc<UpdateFollowupDashboardEvent, UpdateFollowupDashboardState> {
  UpdateFollowupDashboardBloc() : super(UpdateFollowupDashboardInitial()) {
    on<LoadUpdateFollowupDashboard>(loadUpdateFollowupDashboard);
  }

  Future<void> loadUpdateFollowupDashboard(
    LoadUpdateFollowupDashboard event,
    Emitter<UpdateFollowupDashboardState> emit,
  ) async {
    emit(UpdateFollowupDashboardLoading());
    try {
      List<UpdateFollowUpDashboardModel> updateFollowupData = [];

      await GlobalAPI.fetchUpdateFollowupDashboard(
        event.salesmanId,
        event.mobilePhone,
        event.prospectDate,
      ).then((response) {
        if (response['status'] == 'sukses') {
          updateFollowupData
              .addAll(response['data'] as List<UpdateFollowUpDashboardModel>);
          emit(UpdateFollowupDashboardLoaded(updateFollowupData));
        } else {
          emit(UpdateFollowupDashboardError(response['data'].toString()));
        }
      });
    } catch (e) {
      emit(UpdateFollowupDashboardError(e.toString()));
    }
  }
}
