import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/model.dart';
import 'sales_dashboard_event.dart';
import 'sales_dashboard_state.dart';

class SalesDashboardBloc
    extends Bloc<SalesDashboardEvent, SalesDashboardState> {
  SalesDashboardBloc() : super(SalesDashboardInitial()) {
    on<LoadSalesDashboard>(loadSalesDashboard);
  }

  Future<void> loadSalesDashboard(
    LoadSalesDashboard event,
    Emitter<SalesDashboardState> emit,
  ) async {
    emit(SalesDashboardLoading());
    try {
      List<SalesmanDashboardModel> salesData = [];

      await GlobalAPI.fetchSalesmanDashboard(
        event.salesmanId,
        event.date,
      ).then((response) {
        if (response['status'] == 'sukses') {
          salesData.addAll(response['data'] as List<SalesmanDashboardModel>);
        }
      });

      emit(SalesDashboardLoaded(salesData));
    } catch (e) {
      emit(SalesDashboardError(e.toString()));
    }
  }
}
