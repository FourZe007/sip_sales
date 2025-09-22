import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_sales/global/api.dart';
import 'package:sip_sales/global/enum.dart';
import 'package:sip_sales/global/formatter.dart';
import 'package:sip_sales/global/model.dart';
import 'package:sip_sales/global/state/coordinatordashboard/coord_dashboard_bloc.dart';
import 'package:sip_sales/global/state/coordinatordashboard/coord_dashboard_event.dart';
import 'package:sip_sales/global/state/dashboardtype_cubit.dart';
import 'package:sip_sales/global/state/login/login_event.dart';
import 'package:sip_sales/global/state/login/login_state.dart';

class LoginBloc extends Bloc<AccountEvent, LoginState> {
  LoginBloc() : super(LoginInit()) {
    on<AccountEvent>(login);
  }

  Future<void> login(
    AccountEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoginLoading());
      if (event.id.isNotEmpty && event.pass.isNotEmpty) {
        event.appState.readAndWriteUserId(id: event.id, isLogin: true);
        event.appState.readAndWriteUserPass(pass: event.pass, isLogin: true);
        event.appState.readAndWriteDeviceConfig();

        final uuid = await event.appState.generateUuid();

        await GlobalAPI.fetchUserAccount(
          event.id,
          event.pass,
          uuid,
          event.appState.getDeviceConfiguration,
        ).then((List<ModelUser> res) {
          if (res[0].flag == 1) {
            event.appState.setUserAccountList(res);
          } else {
            emit(LoginFailed(Formatter.toTitleCase(res[0].memo)));
            return;
          }
        });

        if (event.appState.getUserAccountList.isNotEmpty) {
          await event.appState.readAndWriteIsUserManager(
            state:
                event.appState.getUserAccountList[0].code == 0 ? true : false,
            isLogin: true,
          );

          switch (event.appState.getUserAccountList[0].code) {
            // ~:Shop Manager:~
            case 0:
              log('Manager');
              // Note -> get Activity Insertation dropdown for Manager
              await event.appState.fetchManagerActivityData();
              await event.appState.fetchManagerActivities().then((res) {
                event.appState.setManagerActivities(res);
              });
              break;
            // ~:Sales:~
            case 1:
              try {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                // ~:Sales New Activity Insertation:~
                await event.appState.getUserAttendanceHistory();
                // await event.appState.getSalesDashboard();

                // ~:Reset dropdown default value to User's placement:~
                // state.setAbsentType(state.getUserAccountList[0].locationName);

                if (event.appState.getUserAccountList.isNotEmpty &&
                    event.appState.getProfilePicture.isEmpty &&
                    event.appState.getProfilePicturePreview.isEmpty) {
                  event.appState.setProfilePicture(
                    event.appState.getUserAccountList[0].profilePicture,
                  );

                  try {
                    await GlobalAPI.fetchShowImage(
                      event.appState.getUserAccountList[0].employeeID,
                    ).then((String highResImg) async {
                      if (highResImg == 'not available' ||
                          highResImg == 'failed' ||
                          highResImg == 'error') {
                        event.appState.setProfilePicturePreview('');
                        await prefs.setString('highResImage', '');
                        log('High Res Image is not available.');
                      } else {
                        event.appState.setProfilePicturePreview(highResImg);
                        await prefs.setString('highResImage', highResImg);
                        log('High Res Image successfully loaded.');
                        log('High Res Image: $highResImg');
                      }
                    });
                  } catch (e) {
                    log('Show HD Image Error: $e');
                    event.appState.setProfilePicturePreview('');
                    await prefs.setString('highResImage', '');
                  }
                }
                break;
              } catch (e, stackTrace) {
                log('Error in login process: $e');
                log('Stack trace: $stackTrace');
                // Consider emitting an error state here
                emit(LoginFailed('Failed to complete login process'));
                return;
              }
            // ~:Shop Coordinator:~
            case 2:
              log('Shop Coordinator');
              if (event.context.mounted) {
                event.context
                    .read<DashboardTypeCubit>()
                    .changeType(DashboardType.salesman);

                event.context.read<CoordinatorDashboardBloc>().add(
                      LoadCoordinatorDashboard(
                        await event.appState.readAndWriteUserId(),
                        DateTime.now().toIso8601String().substring(0, 10),
                      ),
                    );
              }
              break;
          }

          emit(LoginSuccess(event.appState.getUserAccountList));
        } else {
          emit(LoginFailed('User tidak ditemukan. Coba lagi.'));
        }
      } else {
        emit(LoginFailed('Mohon periksa input anda kembali.'));
      }
    } catch (e) {
      emit(LoginFailed(e.toString()));
    }
  }
}
