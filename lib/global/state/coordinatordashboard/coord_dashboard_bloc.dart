import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/model.dart';
import 'coord_dashboard_event.dart';
import 'coord_dashboard_state.dart';

class CoordinatorDashboardBloc
    extends Bloc<CoordinatorDashboardEvent, CoordinatorDashboardState> {
  CoordinatorDashboardBloc() : super(CoordinatorDashboardInitial()) {
    on<LoadCoordinatorDashboard>(loadCoordinatorDashboard);
  }

  Future<void> loadCoordinatorDashboard(
    LoadCoordinatorDashboard event,
    Emitter<CoordinatorDashboardState> emit,
  ) async {
    emit(CoordinatorDashboardLoading());
    try {
      List<CoordinatorDashboardModel> coordData = [];

      await GlobalAPI.fetchCoordinatorDashboard(
        event.salesmanId,
        event.date,
      ).then((response) {
        if (response['status'] == 'sukses') {
          coordData.addAll(response['data'] as List<CoordinatorDashboardModel>);
        }
      });

      emit(CoordinatorDashboardLoaded(coordData));
    } catch (e) {
      emit(CoordinatorDashboardError(e.toString()));
    }
  }
}
