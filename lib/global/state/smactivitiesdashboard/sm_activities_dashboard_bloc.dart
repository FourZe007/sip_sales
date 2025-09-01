import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state/smactivitiesdashboard/sm_activities_dashboard_event.dart';
import 'package:sip_sales/global/state/smactivitiesdashboard/sm_activities_dashboard_state.dart';

class SMActivitiesDashboardBloc
    extends Bloc<SMActivitiesDashboardEvent, SMActivitiesDashboardState> {
  SMActivitiesDashboardBloc() : super(SMActivitiesDashboardInit()) {
    on<SaveSMActivitiesDashboard>(saveSMActivitiesDashboard);
    on<DeleteSMActivitiesDashboard>(deleteSMActivitiesDashboard);
  }

  Future<void> saveSMActivitiesDashboard(
    SaveSMActivitiesDashboard event,
    Emitter<SMActivitiesDashboardState> emit,
  ) async {
    try {
      emit(SMActivitiesDashboardSaved(
        employeeID: event.employeeID,
        activityID: event.activityID,
      ));
    } catch (e) {
      emit(SMActivitiesDashboardError(e.toString()));
    }
  }

  Future<void> deleteSMActivitiesDashboard(
    DeleteSMActivitiesDashboard event,
    Emitter<SMActivitiesDashboardState> emit,
  ) async {
    emit(SMActivitiesDashboardLoading());
    try {
      await GlobalAPI.fetchNewManagerActivity(
        '2',
        event.employeeID,
        event.date,
        '',
        '',
        '',
        0,
        0,
        event.activityID,
        '',
        [],
      ).then((List<ModelResultMessage2> res) {
        if (res.isNotEmpty) {
          if (res[0].resultMessage.toLowerCase() == 'sukses') {
            emit(SMActivitiesDashboardDeleted());
          } else {
            switch (res[0].resultMessage.toLowerCase()) {
              case '100':
                emit(
                    SMActivitiesDashboardDeletedFailed('Data tidak ditemukan'));
                break;
              case '204':
                emit(
                    SMActivitiesDashboardDeletedFailed('Gagal menghapus data'));
                break;
              case '404':
                emit(SMActivitiesDashboardDeletedFailed(
                    'Terjadi kesalahan saat menghapus data'));
                break;
              default:
                emit(SMActivitiesDashboardDeletedFailed(
                    'Terjadi kesalahan saat menghapus data'));
                break;
            }
          }
        }
      });
    } catch (e) {
      emit(SMActivitiesDashboardDeletedFailed(
          'Terjadi kesalahan saat menghapus data'));
    }
  }
}
