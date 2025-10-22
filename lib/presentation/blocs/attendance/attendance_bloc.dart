import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/radius_checker.dart';
import 'package:sip_sales_clean/domain/repositories/attendance_domain.dart';
import 'package:sip_sales_clean/domain/repositories/radius_checker_domain.dart';
import 'package:sip_sales_clean/presentation/blocs/attendance/attendance_event.dart';
import 'package:sip_sales_clean/presentation/blocs/attendance/attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepo attendanceRepo;
  final RadiusCheckerRepo radiusCheckerRepo;

  AttendanceBloc({
    required this.attendanceRepo,
    required this.radiusCheckerRepo,
  }) : super(AttendanceInitial()) {
    on<DailyAttendance>(_onDailyAttendance);
    on<EventAttendance>(_onEventAttendance);
  }

  Future<void> _onDailyAttendance(
    DailyAttendance event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      emit(DailyAttendanceLoading());

      if (event.employee.profilePicture.isEmpty) {
        emit(DailyAttendanceError(message: 'Harap isi foto'));
        return;
      }

      final radChecker = await radiusCheckerRepo.checkRadius(
        event.employee.latitude,
        event.employee.longitude,
        event.coordinate.latitude,
        event.coordinate.longitude,
      );

      final isClose = (radChecker['data'] as RadiusCheckerModel).isClose;
      final isSuccess = radChecker['status'] == 'success';

      if (isSuccess && isClose == 'OK') {
        final res = await attendanceRepo.dailyAttendance(
          event.employee,
          event.date,
          event.time,
          event.coordinate,
        );

        final isAttendanceSuccess =
            res['status'] == 'success' &&
            res['code'] == '100' &&
            res['data'].toString().toLowerCase() == 'sukses';

        if (isAttendanceSuccess) {
          emit(DailyAttendanceSuccess());
        } else {
          emit(
            DailyAttendanceError(
              message: Formatter.toFirstLetterUpperCase(res['data']),
            ),
          );
        }
      } else {
        final errorMessage = isClose == 'NOT OK'
            ? 'Absen gagal karena Anda berada di luar radius.'
            : 'Terjadi kesalahan.';
        emit(DailyAttendanceError(message: errorMessage));
      }
    } catch (e) {
      emit(DailyAttendanceError(message: e.toString()));
    }
  }

  Future<void> _onEventAttendance(
    EventAttendance event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      emit(EventAttendanceLoading());

      if (event.eventDesc.isEmpty || event.image.isEmpty) {
        emit(EventAttendanceError(message: 'Harap isi deskripsi dan foto'));
      } else {
        final res = await attendanceRepo.eventAttendance(
          event.employee,
          event.date,
          event.time,
          event.coordinate,
          event.eventDesc,
          event.image,
        );

        if (res['status'] == 'success' &&
            res['code'] == '100' &&
            res['data'].toString().toLowerCase() == 'sukses') {
          emit(EventAttendanceSuccess());
        } else {
          emit(
            EventAttendanceError(
              message: Formatter.toFirstLetterUpperCase(res['data']),
            ),
          );
        }
      }
    } catch (e) {
      emit(EventAttendanceError(message: e.toString()));
    }
  }
}
