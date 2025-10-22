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
            if (response['status'] == 'success' && response['code'] == '100') {
              emit(CoordinatorDashboardLoaded(response['data']));
            } else if (response['status'] == 'fail' &&
                response['code'] != '100') {
              emit(CoordinatorDashboardError(response['code']));
            } else {
              emit(CoordinatorDashboardError('Terjadi kesalahan'));
            }
          });
    } catch (e) {
      emit(CoordinatorDashboardError(e.toString()));
    }
  }
}
