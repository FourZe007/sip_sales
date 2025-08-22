import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/enum.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state/dashboard_slidingup_cubit.dart';
import 'package:sip_sales/global/state/followupdashboard/followup_dashboard_bloc.dart';
import 'package:sip_sales/global/state/followupdashboard/followup_dashboard_state.dart';
import 'package:sip_sales/global/state/followupdate_cubit.dart';
import 'package:sip_sales/global/state/provider.dart';
import 'package:sip_sales/global/state/updatefollowupdashboard/update_followup_dashboard_bloc.dart';
import 'package:sip_sales/global/state/updatefollowupdashboard/update_followup_dashboard_event.dart';
import 'package:sip_sales/pages/screen/followup_dashboard_detail.dart';
import 'package:sip_sales/widget/data/fu_dashboard_header.dart';
import 'package:sip_sales/widget/format.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
import 'package:flutter/cupertino.dart';

class FollowupDashboard extends StatelessWidget {
  const FollowupDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<SipSalesState>(context);
    final updateFollowupDashboardBloc =
        context.read<UpdateFollowupDashboardBloc>();
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
            return const CircleLoading(
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
          // return Center(
          //   child: Text('Followup Dashboard data loaded'),
          // );
          return ListView.builder(
            itemCount: state.salesData.length,
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 8.0),
            itemBuilder: (context, index) {
              final salesData = state.salesData[index];

              return Column(
                spacing: 8,
                children: [
                  // ~:Follow Up Header:~
                  FuDashboardHeader(
                    fuData: salesData,
                    isFuDeal: false,
                  ),

                  // ~:Follow-Up Detail:~
                  Column(
                    children: salesData.detail.map((e) {
                      final icon = switch (
                          e.fuStatus.toLowerCase().replaceAll(' ', '')) {
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
                                          style: GlobalFont.mediumfontRBold
                                              .copyWith(fontSize: 14),
                                        ),
                                        Text(
                                          e.prospectDateFormat,
                                          style: GlobalFont.mediumfontR,
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
                                            style: GlobalFont.mediumfontR,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            Format.toSentenceUpperCase(
                                                e.customerName),
                                            style: GlobalFont.mediumfontR
                                                .copyWith(fontSize: 14),
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
                                            style: GlobalFont.mediumfontR,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            e.mobilePhone,
                                            style: GlobalFont.mediumfontR,
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
                                            style: GlobalFont.mediumfontR,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            e.customerStatus,
                                            style: GlobalFont.mediumfontR,
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
                                            style: GlobalFont.mediumfontR,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            e.prospectDate,
                                            style: GlobalFont.mediumfontR,
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
                                                      style: GlobalFont
                                                          .mediumfontR,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      e.lastFUDate,
                                                      style: GlobalFont
                                                          .mediumfontR,
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
                                                      style: GlobalFont
                                                          .mediumfontR,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      Format
                                                          .toFirstLetterUpperCase(
                                                        e.lastFUMemo,
                                                      ),
                                                      style: GlobalFont
                                                          .mediumfontR,
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
                                                      style: GlobalFont
                                                          .mediumfontR,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      e.nextFUDate,
                                                      style: GlobalFont
                                                          .mediumfontR,
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
                                    final salesmanId =
                                        appState.getUserAccountList.isNotEmpty
                                            ? appState.getUserAccountList[0]
                                                .employeeID
                                            : '';

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
                                  child: Text(
                                    'Update',
                                    style: GlobalFont.mediumfontRWhite
                                        .copyWith(fontSize: 14),
                                  ),
                                ),
                              )
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
