import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/core/constant/enum.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/domain/repositories/login_domain.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_event.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/blocs/shop_coordinator/shop_coordinator_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/shop_coordinator/shop_coordinator_event.dart';
import 'package:sip_sales_clean/presentation/cubit/dashboard_type.dart';
import 'package:sip_sales_clean/presentation/cubit/head_act_types.dart';
import 'package:sip_sales_clean/presentation/cubit/spk_leasing_filter_cubit.dart';
import 'package:sip_sales_clean/presentation/functions.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepo loginRepo;

  LoginBloc({required this.loginRepo}) : super(LoginInit()) {
    on<LoginButtonPressed>(login);
    on<LogoutButtonPressed>(logout);
  }

  Future<void> login(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoginLoading(isRefresh: event.isRefresh));

      // Determine credentials: use provided ones (explicit login), otherwise try stored ones (auto-login)
      String savedEmployeeId = '';
      String savedUserPass = '';

      if (event.id.isNotEmpty && event.pass.isNotEmpty) {
        // Explicit login attempt: save provided credentials
        savedEmployeeId = await Functions.readAndWriteEmployeeId(
          id: event.id,
          isLogin: true,
        );
        savedUserPass = await Functions.readAndWriteUserPass(
          pass: event.pass,
          isLogin: true,
        );
      } else {
        // Auto-login attempt from stored secure storage
        savedEmployeeId = await Functions.readAndWriteEmployeeId();
        savedUserPass = await Functions.readAndWriteUserPass();
      }

      if (savedEmployeeId.isNotEmpty && savedUserPass.isNotEmpty) {
        final uuid = await Functions.generateUuid();
        final deviceConfig = await Functions.readAndWriteDeviceConfig();

        final loginRes = await loginRepo.login(
          savedEmployeeId,
          savedUserPass,
          uuid,
          deviceConfig,
        );

        log(loginRes.toString());
        log('Flag: ${loginRes['data'].flag}');

        if (loginRes['status'] == 'success') {
          log('Login Success');
          if (loginRes['data'].flag == 1) {
            // event.appState.setUserAccountList(res);
            switch (loginRes['data'].code) {
              // ~:Shop Manager:~
              case 0:
                log('Head Store');
                if (event.context.mounted) {
                  event.context.read<SpkLeasingFilterCubit>().loadFilterData();
                  event.context.read<HeadActTypesCubit>().fetchActTypes();
                }
                break;
              // ~:Sales:~
              case 1:
                try {
                  // Do nothing
                  // final SharedPreferences prefs =
                  //     await SharedPreferences.getInstance();
                  //
                  // // ~:Sales New Activity Insertation:~
                  // MOVE TO LOCATION SCREEN
                  // await event.appState.getUserAttendanceHistory();
                  // // await event.appState.getSalesDashboard();
                  //
                  // // ~:Reset dropdown default value to User's placement:~
                  // // state.setAbsentType(state.getUserAccountList[0].locationName);
                  //
                  //
                  // MOVE TO PROFILE SCREEN
                  // if (event.appState.getUserAccountList.isNotEmpty &&
                  //     event.appState.getProfilePicture.isEmpty &&
                  //     event.appState.getProfilePicturePreview.isEmpty) {
                  //   event.appState.setProfilePicture(
                  //     event.appState.getUserAccountList[0].profilePicture,
                  //   );
                  //
                  //   try {
                  //     await GlobalAPI.fetchShowImage(
                  //       event.appState.getUserAccountList[0].employeeID,
                  //     ).then((String highResImg) async {
                  //       if (highResImg == 'not available' ||
                  //           highResImg == 'failed' ||
                  //           highResImg == 'error') {
                  //         event.appState.setProfilePicturePreview('');
                  //         await prefs.setString('highResImage', '');
                  //         log('High Res Image is not available.');
                  //       } else {
                  //         event.appState.setProfilePicturePreview(highResImg);
                  //         await prefs.setString('highResImage', highResImg);
                  //         log('High Res Image successfully loaded.');
                  //         log('High Res Image: $highResImg');
                  //       }
                  //     });
                  //   } catch (e) {
                  //     log('Show HD Image Error: $e');
                  //     event.appState.setProfilePicturePreview('');
                  //     await prefs.setString('highResImage', '');
                  //   }
                  // }
                  break;
                } catch (e, stackTrace) {
                  log('Error in login process: $e');
                  log('Stack trace: $stackTrace');
                  // Consider emitting an error state here
                  emit(
                    LoginFailed(
                      message: 'Failed to complete login process',
                      isRefresh: event.isRefresh,
                    ),
                  );
                  return;
                }
              // ~:Shop Coordinator:~
              case 2:
                log('Shop Coordinator');
                if (event.context.mounted) {
                  event.context.read<DashboardTypeCubit>().changeType(
                    DashboardType.salesman,
                  );

                  event.context.read<ShopCoordinatorBloc>().add(
                    LoadCoordinatorDashboard(
                      loginRes['data'].employeeID,
                      DateTime.now().toIso8601String().substring(0, 10),
                    ),
                  );
                }
                break;
            }

            emit(
              LoginSuccess(user: loginRes['data'], isRefresh: event.isRefresh),
            );
          } else {
            log('User not found');
            emit(
              LoginFailed(
                message: Formatter.toTitleCase(loginRes['data'].memo),
                isRefresh: event.isRefresh,
              ),
            );
            return;
          }
        } else {
          log('Login failed');
          emit(
            LoginFailed(
              message: Formatter.toTitleCase(loginRes['data'].memo),
              isRefresh: event.isRefresh,
            ),
          );
          return;
        }
      } else {
        // No credentials available, treat as unauthenticated
        log('No credentials available');
        emit(LoginUnauthenticated());
      }
    } catch (e) {
      if (e is PlatformException && e.code == 'BadPaddingException') {
        log('Clearing all data');
        await Functions.clearAllData();
      }
      log('Login Error: $e');
      emit(LoginFailed(message: e.toString(), isRefresh: event.isRefresh));
    }
  }

  Future<void> logout(
    LogoutButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LogoutLoading());
      await Functions.clearAllData();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailed(e.toString()));
    }
  }
}
