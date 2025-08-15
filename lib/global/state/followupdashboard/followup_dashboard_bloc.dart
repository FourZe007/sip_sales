import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/model.dart';
import 'followup_dashboard_event.dart';
import 'followup_dashboard_state.dart';

class FollowupDashboardBloc
    extends Bloc<FollowupDashboardEvent, FollowupDashboardState> {
  FollowupDashboardBloc() : super(FollowupDashboardInitial()) {
    on<LoadFollowupDashboard>(loadFollowupDashboard);
  }

  Future<void> loadFollowupDashboard(
    LoadFollowupDashboard event,
    Emitter<FollowupDashboardState> emit,
  ) async {
    emit(FollowupDashboardLoading());
    try {
      List<FollowUpDashboardModel> followupData = [];

      await GlobalAPI.fetchFollowupDashboard(
        event.salesmanId,
        event.date,
      ).then((response) {
        if (response['status'] == 'sukses' &&
            (response['data'] as List).isNotEmpty) {
          followupData.addAll(response['data'] as List<FollowUpDashboardModel>);
          emit(FollowupDashboardLoaded(followupData));
        } else if (response['status'] == 'sukses' &&
            (response['data'] as List).isEmpty) {
          emit(FollowupDashboardError('empty'));
        } else {
          emit(FollowupDashboardError(response['data'].toString()));
        }
      });
    } catch (e) {
      emit(FollowupDashboardError(e.toString()));
    }
  }
}
