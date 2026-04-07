import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/repositories/dashboard_data.dart';
import 'package:sip_sales_clean/presentation/blocs/shop_coordinator/shop_coordinator_event.dart';
import 'package:sip_sales_clean/presentation/blocs/shop_coordinator/shop_coordinator_state.dart';

class ShopCoordinatorBloc
    extends Bloc<ShopCoordinatorEvent, ShopCoordinatorState> {
  ShopCoordinatorBloc() : super(ShopCoordinatorInitial()) {
    on<LoadCoordinatorDashboard>(loadCoordinatorDashboard);
  }

  Future<void> loadCoordinatorDashboard(
    LoadCoordinatorDashboard event,
    Emitter<ShopCoordinatorState> emit,
  ) async {
    emit(CoordinatorDashboardLoading());
    try {
      // List<CoordinatorDashboardModel> coordData = [];

      await DashboardDataImp()
          .fetchCoordinatorDashboard(event.salesmanId, event.date)
          .then((response) {
            final status = response['status'].toString().toLowerCase().trim();
            final code = response['code'].toString();

            if (status == 'success' && code == '100') {
              emit(CoordinatorDashboardLoaded(response['data']));
            } else if (status == 'no data' && code == '100') {
              emit(CoordinatorDashboardEmpty());
            } else if (status == 'fail') {
              emit(CoordinatorDashboardError(code));
            } else {
              emit(CoordinatorDashboardError(response['status'].toString()));
            }
          });
    } catch (e) {
      emit(CoordinatorDashboardError(e.toString()));
    }
  }
}
