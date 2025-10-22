import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/domain/repositories/update_followup_domain.dart';
import 'package:sip_sales_clean/presentation/blocs/update_followup/update_fu_dashboard_event.dart';
import 'package:sip_sales_clean/presentation/blocs/update_followup/update_fu_dashboard_state.dart';

class UpdateFollowupDashboardBloc
    extends Bloc<UpdateFollowupDashboardEvent, UpdateFollowupDashboardState> {
  final UpdateFollowupRepo followupRepo;

  UpdateFollowupDashboardBloc({required this.followupRepo})
    : super(UpdateFollowupDashboardInitial()) {
    on<InitUpdateFollowupResults>(initUpdateFollowupResults);
    on<SelectUpdateFollowupResults>(selectUpdateFollowupResults);
    on<LoadUpdateFollowupDashboard>(loadUpdateFollowupDashboard);
    on<SaveUpdateFollowup>(saveUpdateFollowup);
  }

  Future<void> initUpdateFollowupResults(
    InitUpdateFollowupResults event,
    Emitter<UpdateFollowupDashboardState> emit,
  ) async {
    emit(UpdateFollowupDashboardResultsInitial());
  }

  Future<void> selectUpdateFollowupResults(
    SelectUpdateFollowupResults event,
    Emitter<UpdateFollowupDashboardState> emit,
  ) async {
    try {
      emit(
        UpdateFollowupDashboardResultsSucceed(
          oldResults: [],
          newResult: event.results,
          index: event.index,
        ),
      );
    } catch (e) {
      emit(UpdateFollowupDashboardResultsFailed(e.toString()));
    }
  }

  Future<void> loadUpdateFollowupDashboard(
    LoadUpdateFollowupDashboard event,
    Emitter<UpdateFollowupDashboardState> emit,
  ) async {
    emit(UpdateFollowupDashboardLoading());
    try {
      final updateFollowupData = await followupRepo.fetchUpdateFUDashboard(
        event.salesmanId,
        event.mobilePhone,
        event.prospectDate,
      );

      if (updateFollowupData['status'] == 'success') {
        emit(UpdateFollowupDashboardLoaded(updateFollowupData['data']));
      } else {
        emit(
          UpdateFollowupDashboardError(updateFollowupData['data'].toString()),
        );
      }
    } catch (e) {
      emit(UpdateFollowupDashboardError(e.toString()));
    }
  }

  Future<void> saveUpdateFollowup(
    SaveUpdateFollowup event,
    Emitter<UpdateFollowupDashboardState> emit,
  ) async {
    emit(SaveFollowupLoading());
    try {
      String finalFuResult = '';
      if (event.fuResult.isEmpty) {
        finalFuResult = 'PD';
      } else {
        switch (event.fuResult.toLowerCase()) {
          case 'pending':
            finalFuResult = 'PD';
            break;
          case 'deal':
            finalFuResult = 'DL';
            break;
          case 'cancel':
            finalFuResult = 'CL';
            break;
          default:
            finalFuResult = '';
            break;
        }
      }

      final res = await followupRepo.saveFollowup(
        event.salesmanId,
        event.mobilePhone,
        event.prospectDate,
        event.line,
        event.fuDate,
        event.fuResult,
        event.fuMemo,
        event.nextFUDate,
      );

      if (res['status'] == 'sukses') {
        emit(SaveFollowupSucceed(res['data']));
      } else {
        emit(SaveFollowupFailed(res['data'].toString()));
      }
    } catch (e) {
      emit(SaveFollowupFailed(e.toString()));
    }
  }
}
