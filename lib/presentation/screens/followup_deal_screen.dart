import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/core/constant/enum.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/presentation/blocs/followup/fu_dashboard_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/followup/fu_dashboard_state.dart';
import 'package:sip_sales_clean/presentation/cubit/dashboard_slidingup_cubit.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/templates/fu_dashboard_header.dart';

class FollowupDealDashboard extends StatelessWidget {
  const FollowupDealDashboard({this.employeeId = '', super.key});

  final String employeeId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowupDashboardBloc, FollowupDashboardState>(
      builder: (context, state) {
        if (state is FollowupDealDashboardLoading) {
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
          if (state.dealData.isEmpty) {
            return Column(
              children: [
                // ~:Header:~
                FuDashboardHeader(
                  fuDealData: null,
                  isFuDeal: true,
                ),

                // ~:Body:~
                Expanded(
                  child: const Center(
                    child: Text(
                      'Data Tidak Ditemukan',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return ListView.builder(
              itemCount: state.dealData.length,
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 8.0),
              itemBuilder: (context, index) {
                final dealData = state.dealData[index];

                return Column(
                  spacing: 8,
                  children: [
                    // ~:Follow Up Header:~
                    FuDashboardHeader(
                      fuDealData: dealData,
                      isFuDeal: true,
                    ),

                    // ~:Follow Up Detail:~
                    Column(
                      children: dealData.detail.map((e) {
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
                                            style: TextThemes.normal.copyWith(
                                              fontWeight: FontWeight.w600,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              Formatter.toTitleCase(
                                                e.customerName,
                                              ),
                                              style: TextThemes.normal.copyWith(
                                                fontSize: 14,
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
                                              e.prospectDateFormat,
                                              style: TextThemes.normal.copyWith(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // ~:SPK Number:~
                                      Builder(
                                        builder: (context) {
                                          if (e.noSPK.isNotEmpty) {
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'No. SPK',
                                                    style: TextThemes.normal
                                                        .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    e.noSPK,
                                                    style: TextThemes.normal
                                                        .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return SizedBox.shrink();
                                          }
                                        },
                                      ),

                                      // ~:SPK Date:~
                                      Builder(
                                        builder: (context) {
                                          if (e.tglSPK.isNotEmpty) {
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Tgl SPK',
                                                    style: TextThemes.normal
                                                        .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    e.tglSPK,
                                                    style: TextThemes.normal
                                                        .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return SizedBox.shrink();
                                          }
                                        },
                                      ),

                                      // ~:Payment Method:~
                                      Builder(
                                        builder: (context) {
                                          if (e.pembayaran.isNotEmpty) {
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Payment',
                                                    style: TextThemes.normal
                                                        .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    e.pembayaran,
                                                    style: TextThemes.normal
                                                        .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return SizedBox.shrink();
                                          }
                                        },
                                      ),

                                      // ~:Delivery:~
                                      Builder(
                                        builder: (context) {
                                          if (e.noSJ.isNotEmpty) {
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Delivery',
                                                    style: TextThemes.normal
                                                        .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    e.noSJ,
                                                    style: TextThemes.normal
                                                        .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return SizedBox.shrink();
                                          }
                                        },
                                      ),

                                      // ~:Delivery Date:~
                                      Builder(
                                        builder: (context) {
                                          if (e.tglSJ.isNotEmpty) {
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Tgl Delivery',
                                                    style: TextThemes.normal
                                                        .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    e.tglSJ,
                                                    style: TextThemes.normal
                                                        .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return SizedBox.shrink();
                                          }
                                        },
                                      ),

                                      // ~:Chasis Number:~
                                      Builder(
                                        builder: (context) {
                                          if (e.chasisNo.isNotEmpty) {
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'No. Chasis',
                                                    style: TextThemes.normal
                                                        .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    e.chasisNo,
                                                    style: TextThemes.normal
                                                        .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return SizedBox.shrink();
                                          }
                                        },
                                      ),
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
          }
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
