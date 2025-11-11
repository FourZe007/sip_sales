// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sip_sales_clean/presentation/blocs/attendance/attendance_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/attendance/attendance_event.dart';
import 'package:sip_sales_clean/presentation/blocs/attendance/attendance_state.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/blocs/radius_checker/radius_checker_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/radius_checker/radius_checker_event.dart';
import 'package:sip_sales_clean/presentation/blocs/radius_checker/radius_checker_state.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman/salesman_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman/salesman_event.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman/salesman_state.dart';
import 'package:sip_sales_clean/presentation/cubit/attendance_type_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/image_cubit.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/screens/salesman_attendance_more_screen.dart';
import 'package:sip_sales_clean/presentation/screens/salesman_attendance_event_screen.dart';
import 'package:sip_sales_clean/presentation/screens/salesman_location_screen.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/buttons/attendance_list.dart';
import 'package:sip_sales_clean/presentation/widgets/date_time/digital_clock.dart';
import 'package:sip_sales_clean/presentation/widgets/dropdown/salesman_attandance_type.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:device_type/device_type.dart';

class SalesmanAttendanceScreen extends StatefulWidget {
  const SalesmanAttendanceScreen({required this.salesmanId, super.key});

  final String salesmanId;

  @override
  State<SalesmanAttendanceScreen> createState() =>
      _SalesmanAttendanceScreenState();
}

class _SalesmanAttendanceScreenState extends State<SalesmanAttendanceScreen> {
  void openMap(BuildContext context) async {
    final loginState = (context.read<LoginBloc>().state as LoginSuccess);
    final position = await Geolocator.getCurrentPosition();

    if (context.mounted) {
      context.read<RadiusCheckerBloc>().add(
        RadiusCheckerEventCheck(
          userLat: loginState.user.latitude,
          userLng: loginState.user.longitude,
          currentLat: position.latitude,
          currentLng: position.longitude,
        ),
      );
    }
  }

  void attendance(BuildContext context, bool isEvent) async {
    Functions.customFlutterToast('Mohon tunggu sebentar...');
    if (isEvent) {
      // Navigate to Event Attendance Screen
      log('Event Attendance');
      context.read<ImageCubit>().clearImage();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SalesmanAttendanceEventScreen(),
        ),
      );
    } else {
      log('Daily Attendance');
      // final radiusCheckerState = context.read<RadiusCheckerBloc>().state;
      // if (radiusCheckerState is RadiusCheckerInit) {
      //   log('RadiusCheckerInit');
      //   context.read<RadiusCheckerBloc>().add(
      //     RadiusCheckerEventCheck(
      //       userLat:
      //           (context.read<LoginBloc>().state as LoginSuccess).user.latitude,
      //       userLng: (context.read<LoginBloc>().state as LoginSuccess)
      //           .user
      //           .longitude,
      //       currentLat: (await Geolocator.getCurrentPosition()).latitude,
      //       currentLng: (await Geolocator.getCurrentPosition()).longitude,
      //       isInit: true,
      //     ),
      //   );
      // } else if (radiusCheckerState is RadiusCheckerError) {
      //   log(radiusCheckerState.message);
      //   log(radiusCheckerState.isRefresh.toString());
      // } else if (radiusCheckerState is RadiusCheckerSuccess) {
      //   log(radiusCheckerState.isRefresh.toString());
      // }

      context.read<AttendanceBloc>().add(
        DailyAttendance(
          employee: (context.read<LoginBloc>().state as LoginSuccess).user,
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          time: DateFormat('HH:mm').format(DateTime.now()),
          coordinate: await Geolocator.getCurrentPosition(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 36, 20, 12),
      child: Column(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ~:Date and Time:~
          CustomDigitalClock(
            // isIpad: (MediaQuery.of(context).size.width < 800) ? false : true,
            deviceType: DeviceType.getDeviceType(context).toLowerCase(),
          ),

          // ~:Attendance Box:~
          Container(
            width: MediaQuery.of(context).size.width,
            height: 128,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                  spreadRadius: 0.8,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ~:Clock In Section:~
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.005,
                    vertical: MediaQuery.of(context).size.height * 0.005,
                  ),
                  child: Row(
                    spacing: 12,
                    children: [
                      // ~:Absent Type:~
                      Expanded(
                        child: SalesmanAttandanceTypeDropdown(),
                      ),

                      // ~:Clock In Button:~
                      Expanded(
                        child: BlocBuilder<AttendanceTypeCubit, String>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: () async => attendance(
                                context,
                                state == 'EVENT' ? true : false,
                              ),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                      spreadRadius: 1.0,
                                    ),
                                  ],
                                ),
                                child: BlocConsumer<AttendanceBloc, AttendanceState>(
                                  // buildWhen: (previous, current) =>
                                  //     current is DailyAttendanceLoading ||
                                  //     current is DailyAttendanceSuccess ||
                                  //     current is DailyAttendanceError,
                                  listener: (context, state) {
                                    if (state is DailyAttendanceError ||
                                        state is EventAttendanceError) {
                                      if (state is DailyAttendanceError) {
                                        Functions.customFlutterToast(
                                          state.message,
                                        );
                                      } else if (state
                                          is EventAttendanceError) {
                                        Functions.customFlutterToast(
                                          state.message,
                                        );
                                      }
                                    } else if (state
                                            is DailyAttendanceSuccess ||
                                        state is EventAttendanceSuccess) {
                                      Functions.customFlutterToast(
                                        'Anda berhasil absen.',
                                      );

                                      context.read<SalesmanBloc>().add(
                                        SalesmanButtonPressed(
                                          salesmanId: widget.salesmanId,
                                          startDate: '',
                                          endDate: '',
                                        ),
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is DailyAttendanceLoading ||
                                        state is EventAttendanceLoading) {
                                      if (Platform.isIOS) {
                                        return const CupertinoActivityIndicator(
                                          radius: 12.5,
                                          color: Colors.black,
                                        );
                                      } else {
                                        return const AndroidLoading(
                                          warna: Colors.black,
                                          strokeWidth: 3,
                                        );
                                      }
                                    } else {
                                      return Text(
                                        'Clock In',
                                        style: TextThemes.normal.copyWith(
                                          fontSize: 16,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // ~:Current Location Button:~
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.005,
                    vertical: MediaQuery.of(context).size.height * 0.005,
                  ),
                  child: GestureDetector(
                    onTap: () => openMap(context),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child:
                          BlocConsumer<RadiusCheckerBloc, RadiusCheckerState>(
                            buildWhen: (previous, current) =>
                                (current is RadiusCheckerLoading &&
                                    !current.isRefresh) ||
                                (current is RadiusCheckerSuccess &&
                                    !current.isRefresh) ||
                                (current is RadiusCheckerError &&
                                    !current.isRefresh),
                            listener: (context, state) async {
                              log('Radius Checker State: $state');

                              if (state is RadiusCheckerError &&
                                  !state.isRefresh) {
                                log('isRefresh: ${state.isRefresh.toString()}');
                                Functions.customFlutterToast(state.message);
                              } else if (state is RadiusCheckerSuccess &&
                                  !state.isRefresh) {
                                log('isRefresh: ${state.isRefresh.toString()}');
                                final position =
                                    await Geolocator.getCurrentPosition();

                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SalesmanLocationScreen(
                                            lat: position.latitude,
                                            lng: position.longitude,
                                          ),
                                    ),
                                  );
                                }
                              }
                            },
                            builder: (context, state) {
                              if (state is RadiusCheckerLoading &&
                                  !state.isRefresh) {
                                if (Platform.isIOS) {
                                  return const CupertinoActivityIndicator(
                                    radius: 12.5,
                                    color: Colors.black,
                                  );
                                } else {
                                  return const AndroidLoading(
                                    warna: Colors.black,
                                    strokeWidth: 3,
                                  );
                                }
                              } else {
                                return Text(
                                  'Lokasi Anda',
                                  style: TextThemes.normal.copyWith(
                                    fontSize: 16,
                                  ),
                                );
                              }
                            },
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ~:Attendance Section:~
          Expanded(
            flex: 2,
            child: Column(
              spacing: 12,
              children: [
                // ~:Attendance List Header:~
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ~:Attendance List Title:~
                    Text(
                      'Daftar Absensi',
                      style: TextThemes.normal.copyWith(
                        fontSize: 20,
                      ),
                    ),

                    // ~:More Button:~
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SalesmanAttendanceMoreScreen(
                            salesmanId: widget.salesmanId,
                          ),
                        ),
                      ),
                      child: Text(
                        'Lihat Semua',
                        style: TextThemes.normal.copyWith(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),

                // ~:Attendance List Body:~
                Expanded(
                  child: BlocBuilder<SalesmanBloc, SalesmanState>(
                    buildWhen: (previous, current) =>
                        (current is SalesmanLoading) ||
                        current is SalesmanAttendanceSuccess ||
                        current is SalesmanAttendanceFailed,
                    builder: (context, state) {
                      if (state is SalesmanLoading) {
                        if (Platform.isIOS) {
                          return const CupertinoActivityIndicator(
                            radius: 12.5,
                            color: Colors.black,
                          );
                        } else {
                          return const AndroidLoading(
                            warna: Colors.black,
                            strokeWidth: 3,
                          );
                        }
                      } else if (state is SalesmanAttendanceFailed) {
                        return const Center(
                          child: Text('Something went wrong'),
                        );
                      } else if (state is SalesmanAttendanceSuccess) {
                        return ListView.builder(
                          itemCount: state.data.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index < 3) {
                              return AttendanceList(
                                attendanceData: state.data[index],
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        );
                      } else {
                        return const Center(
                          child: Text('Tidak ada data.'),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
