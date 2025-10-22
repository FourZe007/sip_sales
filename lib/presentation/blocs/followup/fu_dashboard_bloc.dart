import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/domain/repositories/followup_domain.dart';
import 'package:sip_sales_clean/presentation/blocs/followup/fu_dashboard_event.dart';
import 'package:sip_sales_clean/presentation/blocs/followup/fu_dashboard_state.dart';

class FollowupDashboardBloc
    extends Bloc<FollowupDashboardEvent, FollowupDashboardState> {
  final FollowupRepo followupRepo;

  FollowupDashboardBloc({required this.followupRepo})
    : super(FollowupDashboardInitial()) {
    on<LoadFollowupDashboard>(loadFollowupDashboard);
    on<LoadFollowupDealDashboard>(loadFollowupDealDashboard);
  }

  Future<void> loadFollowupDashboard(
    LoadFollowupDashboard event,
    Emitter<FollowupDashboardState> emit,
  ) async {
    emit(FollowupDashboardLoading());
    try {
      final followupData = await followupRepo.fetchFollowupDashboard(
        event.salesmanId,
        event.date,
        event.sortByName,
      );

      if (followupData['status'] == 'sukses' &&
          (followupData['data'] as List).isNotEmpty) {
        if (event.sortByName) {
          followupData['data'][0].detail.sort(
            (a, b) => a.customerName.compareTo(b.customerName),
          );
        }
        emit(FollowupDashboardLoaded(followupData['data']));
      } else if (followupData['status'] == 'sukses' &&
          (followupData['data'] as List).isEmpty) {
        emit(FollowupDashboardError('empty'));
      } else {
        emit(FollowupDashboardError(followupData['data'].toString()));
      }
    } catch (e) {
      emit(FollowupDashboardError(e.toString()));
    }
  }

  Future<void> loadFollowupDealDashboard(
    LoadFollowupDealDashboard event,
    Emitter<FollowupDashboardState> emit,
  ) async {
    emit(FollowupDealDashboardLoading());
    try {
      final followupDealData = await followupRepo.fetchFollowupDealDashboard(
        event.salesmanId,
        event.date,
        event.sortByName,
      );

      if (followupDealData['status'] == 'sukses' &&
          (followupDealData['data'] as List).isNotEmpty) {
        if (event.sortByName) {
          followupDealData['data'][0].detail.sort(
            (a, b) => a.customerName.compareTo(b.customerName),
          );
        }
        emit(FollowupDealDashboardLoaded(followupDealData['data']));
      } else if (followupDealData['status'] == 'sukses' &&
          (followupDealData['data'] as List).isEmpty) {
        emit(FollowupDealDashboardError('empty'));
      } else {
        emit(FollowupDealDashboardError(followupDealData['data'].toString()));
      }
    } catch (e) {
      emit(FollowupDealDashboardError(e.toString()));
    }
  }
}
