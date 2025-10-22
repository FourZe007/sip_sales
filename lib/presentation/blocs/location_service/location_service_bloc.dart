// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store.event.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/location_service/location_service_event.dart';
import 'package:sip_sales_clean/presentation/blocs/location_service/location_service_state.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman/salesman_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman/salesman_event.dart';
import 'package:sip_sales_clean/presentation/cubit/attendance_type_cubit.dart';
import 'package:sip_sales_clean/presentation/functions.dart';

class LocationServiceBloc
    extends Bloc<LocationServiceEvent, LocationServiceState> {
  LocationServiceBloc() : super(LocationServiceInit()) {
    on<LocationServiceButtonPressed>(_handleLocationService);
  }

  Future<void> _handleLocationService(
    LocationServiceButtonPressed event,
    Emitter<LocationServiceState> emit,
  ) async {
    try {
      emit(LocationServiceLoading());

      final serviceEnabled = await Functions.serviceRequest();
      log('Service enabled: $serviceEnabled');

      if (serviceEnabled) {
        final loginState = (event.context.mounted)
            ? event.context.read<LoginBloc>().state
            : null;
        log('Login state: $loginState');
        if (loginState is LoginSuccess) {
          // ~:Head Store:~
          if (loginState.user.code == 0) {
            log('Fetch Head Acts');
            event.context.read<HeadStoreBloc>().add(
              LoadHeadActs(
                employeeID: loginState.user.employeeID,
                activityID: '',
                date: DateTime.now().toIso8601String().split('T')[0],
              ),
            );

            emit(LocationServiceSuccess());
          }
          // ~:Salesman:~
          else if (loginState.user.code == 1) {
            event.context.read<SalesmanBloc>().add(
              SalesmanButtonPressed(
                salesmanId: loginState.user.employeeID,
                startDate: '',
                endDate: '',
              ),
            );

            event.context.read<AttendanceTypeCubit>().changeType(
              loginState.user.locationName,
            );

            emit(LocationServiceSuccess());
          }
          // ~:Access Rights not found or Access Right equal to Shop Coordinator:~
          // Shop Coordinators do not need any location service to use the app.
          else {
            log('Access rights not found');
            emit(LocationServiceFailed('Access rights not found'));
          }
        } else {
          log('User is not logged in');
          emit(LocationServiceFailed('Login failed'));
        }
      } else {
        log('Location service is disabled');
        emit(LocationServiceFailed('Location service is disabled'));
      }
    } catch (e) {
      log('Error: ${e.toString()}');
      emit(LocationServiceFailed(e.toString()));
    }
  }
}
