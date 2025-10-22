import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/models/salesman.dart';
import 'package:sip_sales_clean/domain/repositories/salesman_domain.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman/salesman_event.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman/salesman_state.dart';

class SalesmanBloc extends Bloc<SalesmanEvent, SalesmanState> {
  final SalesmanRepo salesmanRepo;

  SalesmanBloc({required this.salesmanRepo}) : super(SalesmanInit()) {
    on<SalesmanButtonPressed>(loadSalesmanAttendance);
    on<SalesmanDashboardButtonPressed>(loadSalesmanDashboard);
  }

  Future<void> loadSalesmanAttendance(
    SalesmanButtonPressed event,
    Emitter<SalesmanState> emit,
  ) async {
    try {
      emit(SalesmanLoading());

      final res = await salesmanRepo.loadAttendance(
        event.salesmanId,
        event.startDate,
        event.endDate,
      );

      final String status = res['status'];
      final String code = res['code'];
      final List<SalesmanAttendanceModel> data = res['data'];

      if (status == 'success' && code == '100') {
        emit(SalesmanAttendanceSuccess(data));
      } else {
        emit(SalesmanAttendanceFailed(code));
      }
    } catch (e) {
      emit(SalesmanAttendanceFailed(e.toString()));
    }
  }

  Future<void> loadSalesmanDashboard(
    SalesmanDashboardButtonPressed event,
    Emitter<SalesmanState> emit,
  ) async {
    try {
      emit(SalesmanDashboardLoading());

      final res = await salesmanRepo.loadDashboard(
        event.salesmanId,
        event.endDate,
      );

      final String status = res['status'];
      final String code = res['code'];
      final List<SalesmanDashboardModel> data = res['data'];

      if (status == 'success' && code == '100') {
        emit(SalesmanDashboardSuccess(data));
      } else {
        emit(SalesmanDashboardFailed(code));
      }
    } catch (e) {
      emit(SalesmanDashboardFailed(e.toString()));
    }
  }
}
