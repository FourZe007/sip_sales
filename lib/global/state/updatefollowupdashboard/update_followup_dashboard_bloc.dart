import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/model.dart';
import 'update_followup_dashboard_event.dart';
import 'update_followup_dashboard_state.dart';

class UpdateFollowupDashboardBloc
    extends Bloc<UpdateFollowupDashboardEvent, UpdateFollowupDashboardState> {
  UpdateFollowupDashboardBloc() : super(UpdateFollowupDashboardInitial()) {
    // on<UpdateFollowupDate>(updateFollowUpDate);
    on<InitUpdateFollowupResults>(initUpdateFollowupResults);
    on<SelectUpdateFollowupResults>(selectUpdateFollowupResults);
    on<LoadUpdateFollowupDashboard>(loadUpdateFollowupDashboard);
    on<SaveUpdateFollowup>(saveUpdateFollowup);
  }

  // Future<void> updateFollowUpDate(
  //   UpdateFollowupDate event,
  //   Emitter<UpdateFollowupDashboardState> emit,
  // ) async {
  //   try {
  //     if (event.mode == 1) {
  //       emit(UpdateFollowUpDateSuccess(event.fuData));
  //     } else if (event.mode == 2) {
  //       emit(UpdateNextFollowUpDateSuccess(event.fuData));
  //     } else {
  //       emit(UpdateFollowUpDateFailed('Mode tidak ditemukan'));
  //     }
  //   } catch (e) {
  //     emit(UpdateFollowUpDateFailed(e.toString()));
  //   }
  // }

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
      emit(UpdateFollowupDashboardResultsSucceed(
          oldResults: [], newResult: event.results, index: event.index));
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

      await GlobalAPI.saveFollowup(
        event.salesmanId,
        event.mobilePhone,
        event.prospectDate,
        event.line,
        event.fuDate,
        event.fuResult,
        event.fuMemo,
        event.nextFUDate,
      ).then((response) {
        if (response['status'] == 'sukses') {
          emit(SaveFollowupSucceed(response['data']));
        } else {
          emit(SaveFollowupFailed(response['data'].toString()));
        }
      });
    } catch (e) {
      emit(SaveFollowupFailed(e.toString()));
    }
  }
}
