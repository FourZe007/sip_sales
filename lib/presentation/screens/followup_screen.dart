import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:sip_sales_clean/core/constant/enum.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/presentation/blocs/followup/fu_dashboard_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/followup/fu_dashboard_state.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/blocs/update_followup/update_fu_dashboard_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/update_followup/update_fu_dashboard_event.dart';
import 'package:sip_sales_clean/presentation/cubit/dashboard_slidingup_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/fu_cubit.dart';
import 'package:sip_sales_clean/presentation/screens/followup_details_screen.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/templates/fu_dashboard_header.dart';

class FollowupDashboard extends StatelessWidget {
  const FollowupDashboard({this.employeeId = '', super.key});

  final String employeeId;

  @override
  Widget build(BuildContext context) {
    // final appState = Provider.of<SipSalesState>(context);
    final updateFollowupDashboardBloc = context
        .read<UpdateFollowupDashboardBloc>();
    final followupCubit = context.read<FollowupCubit>();

    return BlocBuilder<FollowupDashboardBloc, FollowupDashboardState>(
      builder: (context, state) {
        if (state is FollowupDashboardLoading) {
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
        } else if (state is FollowupDashboardError) {
          if (state.message == 'empty') {
            return const Center(
              child: Text(
                'Data Tidak Ditemukan',
                textAlign: TextAlign.center,
              ),
            );
          }

          return Center(
            child: Text(
              'Error: ${state.message}',
              textAlign: TextAlign.center,
            ),
          );
        } else if (state is FollowupDashboardLoaded) {
          return ListView.builder(
            itemCount: state.fuData.length,
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 8.0),
            itemBuilder: (context, index) {
              final fuData = state.fuData[index];

              return Column(
                spacing: 8,
                children: [
                  // ~:Follow Up Header:~
                  FuDashboardHeader(
                    fuData: fuData,
                    isFuDeal: false,
                  ),

                  // ~:Follow-Up Detail:~
                  Column(
                    children: fuData.detail.map((e) {
                      final icon = switch (e.fuStatus.toLowerCase().replaceAll(
                        ' ',
                        '',
                      )) {
                        'belumfollowup' => Icons.local_fire_department_outlined,
                        'prosesfollowup' => Icons.person_pin_rounded,
                        'closing' => Icons.check_circle_rounded,
                        'batal' => Icons.cancel_rounded,
                        _ => Icons.question_mark_rounded,
                      };

                      return Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                spacing: 8,
                                children: [
                                  // ~:Icon Status:~
                                  Icon(icon, size: 40),

                                  // ~:Data Status:~
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.fuStatus,
                                          style: TextThemes.normal.copyWith(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          e.prospectDateFormat,
                                          style: TextThemes.normal.copyWith(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // ~:CTA button:~
                                  IconButton(
                                    onPressed: () {
                                      log('More Button pressed');
                                      context
                                          .read<DashboardSlidingUpCubit>()
                                          .changeType(
                                            DashboardSlidingUpType.moreoption,
                                            data: e.mobilePhone,
                                          );
                                    },
                                    icon: Icon(
                                      // FontAwesomeIcons.whatsapp,
                                      Icons.more_vert_rounded,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),

                              // ~:Divider:~
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),

                              // ~:Notes:~
                              Container(
                                width: MediaQuery.of(context).size.width,
                                // height: 164,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Column(
                                  spacing: 4,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ~:Customer Name:~
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Nama',
                                            style: TextThemes.normal.copyWith(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            Formatter.toFirstLetterUpperCase(
                                              e.customerName,
                                            ),
                                            style: TextThemes.normal.copyWith(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // ~:Phone Number:~
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'No. Telp',
                                            style: TextThemes.normal.copyWith(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            e.mobilePhone,
                                            style: TextThemes.normal.copyWith(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // ~:Customer Status:~
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Status',
                                            style: TextThemes.normal.copyWith(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            e.customerStatus,
                                            style: TextThemes.normal.copyWith(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // ~:Prospect Date:~
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Tgl Prospek',
                                            style: TextThemes.normal.copyWith(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            e.prospectDate,
                                            style: TextThemes.normal.copyWith(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // ~:Follow-Up Data:~
                                    Builder(
                                      builder: (context) {
                                        if (e.lastFUDate.isNotEmpty &&
                                            e.lastFUMemo.isNotEmpty &&
                                            e.nextFUDate.isNotEmpty) {
                                          return Wrap(
                                            children: [
                                              // ~:Last Follow-Up Data:~
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Tanggal Follow-Up Terakhir',
                                                      style: TextThemes.normal
                                                          .copyWith(
                                                            fontSize: 12,
                                                          ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      e.lastFUDate,
                                                      style: TextThemes.normal
                                                          .copyWith(
                                                            fontSize: 12,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              // ~:Last Follow-Up Memo:~
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Keterangan',
                                                      style: TextThemes.normal
                                                          .copyWith(
                                                            fontSize: 12,
                                                          ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      Formatter.toFirstLetterUpperCase(
                                                        e.lastFUMemo,
                                                      ),
                                                      style: TextThemes.normal
                                                          .copyWith(
                                                            fontSize: 12,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              // ~:Next Follow-Up Data:~
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Tanggal Follow-Up Berikutnya',
                                                      style: TextThemes.normal
                                                          .copyWith(
                                                            fontSize: 12,
                                                          ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      e.nextFUDate,
                                                      style: TextThemes.normal
                                                          .copyWith(
                                                            fontSize: 12,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              // ~:Update Button:~
                              Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    final loginState = context
                                        .read<LoginBloc>()
                                        .state;
                                    final salesmanId =
                                        (loginState is LoginSuccess &&
                                            loginState.user.code != 1)
                                        ? employeeId
                                        : (loginState as LoginSuccess)
                                              .user
                                              .employeeID;

                                    updateFollowupDashboardBloc.add(
                                      InitUpdateFollowupResults(),
                                    );

                                    log('Salesman ID: $salesmanId');
                                    log('Mobile Phone: ${e.mobilePhone}');
                                    log('Prospect Date: ${e.prospectDate}');
                                    updateFollowupDashboardBloc.add(
                                      LoadUpdateFollowupDashboard(
                                        salesmanId,
                                        e.mobilePhone,
                                        e.prospectDate,
                                      ),
                                    );

                                    followupCubit.resetFollowup();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FollowupDashboardDetail(
                                              mobilePhone: e.mobilePhone,
                                              prospectDate: e.prospectDate,
                                              salesmanId: salesmanId,
                                            ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(92, 32),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    backgroundColor: Colors.black,
                                  ),
                                  child: BlocBuilder<LoginBloc, LoginState>(
                                    builder: (context, state) {
                                      if (state is LoginSuccess &&
                                          state.user.code != 1) {
                                        return Text(
                                          'Lihat detail',
                                          style: TextThemes.normal.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      } else {
                                        return Text(
                                          'Update',
                                          style: TextThemes.normal.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          );
        } else {
          return Center(
            child: Text(
              'No data available',
              textAlign: TextAlign.center,
            ),
          );
        }
      },
    );
  }
}
