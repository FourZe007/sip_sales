import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales/global/enum.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state/dashboard_slidingup_cubit.dart';
import 'package:sip_sales/global/state/followupdashboard/followup_dashboard_bloc.dart';
import 'package:sip_sales/global/state/followupdashboard/followup_dashboard_state.dart';
import 'package:sip_sales/widget/data/fu_dashboard_header.dart';
import 'package:sip_sales/widget/format.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';

class FollowupDealDashboard extends StatelessWidget {
  const FollowupDealDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // final appState = Provider.of<SipSalesState>(context);
    // final updateFollowupDashboardBloc =
    //     context.read<UpdateFollowupDashboardBloc>();
    // final followupCubit = context.read<FollowupCubit>();

    return BlocBuilder<FollowupDashboardBloc, FollowupDashboardState>(
      builder: (context, state) {
        if (state is FollowupDealDashboardLoading) {
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
        } else if (state is FollowupDealDashboardError) {
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
        } else if (state is FollowupDealDashboardLoaded) {
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
                    fuDealData: salesData,
                    isFuDeal: true,
                  ),

                  // ~:Follow Up Detail:~
                  Column(
                    children: salesData.detail.map((e) {
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
                                  Icon(Icons.check_circle_rounded, size: 40),

                                  // ~:Data Status:~
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Deal',
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
                                            e.prospectDateFormat,
                                            style: GlobalFont.mediumfontR,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // ~:SPK Number:~
                                    Builder(builder: (context) {
                                      if (e.noSPK.isNotEmpty) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'No. SPK',
                                                style: GlobalFont.mediumfontR,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                e.noSPK,
                                                style: GlobalFont.mediumfontR,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    }),

                                    // ~:SPK Date:~
                                    Builder(builder: (context) {
                                      if (e.tglSPK.isNotEmpty) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Tgl SPK',
                                                style: GlobalFont.mediumfontR,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                e.tglSPK,
                                                style: GlobalFont.mediumfontR,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    }),

                                    // ~:Payment Method:~
                                    Builder(builder: (context) {
                                      if (e.pembayaran.isNotEmpty) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Payment',
                                                style: GlobalFont.mediumfontR,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                e.pembayaran,
                                                style: GlobalFont.mediumfontR,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    }),

                                    // ~:Delivery:~
                                    Builder(builder: (context) {
                                      if (e.noSJ.isNotEmpty) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Delivery',
                                                style: GlobalFont.mediumfontR,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                e.noSJ,
                                                style: GlobalFont.mediumfontR,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    }),

                                    // ~:Delivery Date:~
                                    Builder(builder: (context) {
                                      if (e.tglSJ.isNotEmpty) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Tgl Delivery',
                                                style: GlobalFont.mediumfontR,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                e.tglSJ,
                                                style: GlobalFont.mediumfontR,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    }),

                                    // ~:Chasis Number:~
                                    Builder(builder: (context) {
                                      if (e.chasisNo.isNotEmpty) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'No. Chasis',
                                                style: GlobalFont.mediumfontR,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                e.chasisNo,
                                                style: GlobalFont.mediumfontR,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    }),
                                  ],
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
