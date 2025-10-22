import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/models/radius_checker.dart';
import 'package:sip_sales_clean/domain/repositories/radius_checker_domain.dart';
import 'package:sip_sales_clean/presentation/blocs/radius_checker/radius_checker_event.dart';
import 'package:sip_sales_clean/presentation/blocs/radius_checker/radius_checker_state.dart';

class RadiusCheckerBloc extends Bloc<RadiusCheckerEvent, RadiusCheckerState> {
  final RadiusCheckerRepo radiusCheckerRepo;

  RadiusCheckerBloc({required this.radiusCheckerRepo})
    : super(RadiusCheckerInit()) {
    on<RadiusCheckerEventCheck>(_onRadiusCheckerEventCheck);
    on<RadiusCheckerInitEvent>(_onRadiusCheckerInitEvent);
  }

  Future<void> _onRadiusCheckerEventCheck(
    RadiusCheckerEventCheck event,
    Emitter<RadiusCheckerState> emit,
  ) async {
    try {
      emit(RadiusCheckerLoading(isRefresh: event.isRefresh));

      final res = await radiusCheckerRepo.checkRadius(
        event.userLat,
        event.userLng,
        event.currentLat,
        event.currentLng,
      );

      if (!event.isRefresh) {
        emit(
          RadiusCheckerSuccess(
            isClose: (res['data'] as RadiusCheckerModel).isClose == 'OK'
                ? true
                : false,
            isRefresh: event.isRefresh,
          ),
        );
      } else {
        if (res['status'] == 'success') {
          log(
            'isClose: ${(res['data'] as RadiusCheckerModel).isClose == 'OK' ? 'OK' : 'NOT OK'}',
          );
          emit(
            RadiusCheckerSuccess(
              isClose: (res['data'] as RadiusCheckerModel).isClose == 'OK',
              isRefresh: event.isRefresh,
            ),
          );
        } else {
          log(res['status']);
          log((res['data'] as RadiusCheckerModel).isClose);
          emit(
            RadiusCheckerError(
              message:
                  'Status code: ${(res['data'] as RadiusCheckerModel).isClose}',
              isRefresh: event.isRefresh,
            ),
          );
        }
      }
    } catch (e) {
      emit(
        RadiusCheckerError(
          message: e.toString(),
          isRefresh: event.isRefresh,
        ),
      );
    }
  }

  Future<void> _onRadiusCheckerInitEvent(
    RadiusCheckerInitEvent event,
    Emitter<RadiusCheckerState> emit,
  ) async {
    try {
      final res = await radiusCheckerRepo.checkRadius(
        event.userLat,
        event.userLng,
        event.currentLat,
        event.currentLng,
      );

      if (res['status'] == 'success' &&
          (res['data'] as RadiusCheckerModel).isClose == 'OK') {
        emit(RadiusCheckerInitSuccess());
      } else {
        if ((res['data'] as RadiusCheckerModel).isClose == 'NOT OK') {
          emit(RadiusCheckerInitError(message: 'Anda berada di luar radius.'));
        } else {
          emit(
            RadiusCheckerInitError(
              message:
                  'Status code: ${(res['data'] as RadiusCheckerModel).isClose}',
            ),
          );
        }
      }
    } catch (e) {
      emit(RadiusCheckerInitError(message: e.toString()));
    }
  }
}
