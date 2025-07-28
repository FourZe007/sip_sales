import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state/followupdashboard/followup_dashboard_bloc.dart';
import 'package:sip_sales/global/state/followupdashboard/followup_dashboard_state.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
import 'package:flutter/cupertino.dart';

class FollowupDashboard extends StatelessWidget {
  const FollowupDashboard({super.key});

  @override
  Widget build(BuildContext context) {
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
          return Column(
            spacing: 20,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  spacing: 8,
                  children: [
                    // ~:Total Prospek:~
                    Container(
                      width: 80,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      child: Column(
                        children: [
                          Container(
                            height: 32,
                            alignment: Alignment.center,
                            child: Text(
                              'Total Prospek',
                              style: GlobalFont.mediumbigfontR.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              state.salesData[0].totalProspect.toString(),
                              style: GlobalFont.giantfontRBold
                                  .copyWith(fontSize: GlobalSize.dateFont1),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ~:Belum Follow-Up:~
                    Container(
                      width: 80,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      child: Column(
                        children: [
                          Container(
                            height: 32,
                            alignment: Alignment.center,
                            child: Text(
                              'Belum Follow Up',
                              style: GlobalFont.mediumbigfontR.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              state.salesData[0].belumFU.toString(),
                              style: GlobalFont.giantfontRBold
                                  .copyWith(fontSize: GlobalSize.dateFont1),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ~:Proses Follow-Up:~
                    Container(
                      width: 80,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.yellow[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      child: Column(
                        children: [
                          Container(
                            height: 32,
                            alignment: Alignment.center,
                            child: Text(
                              'Proses Follow Up',
                              style: GlobalFont.mediumbigfontR.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              state.salesData[0].prosesFU.toString(),
                              style: GlobalFont.giantfontRBold
                                  .copyWith(fontSize: GlobalSize.dateFont1),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ~:Closing:~
                    Container(
                      width: 80,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.green[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      child: Column(
                        children: [
                          Container(
                            height: 32,
                            alignment: Alignment.center,
                            child: Text(
                              'Closing',
                              style: GlobalFont.mediumbigfontR.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              state.salesData[0].closing.toString(),
                              style: GlobalFont.giantfontRBold
                                  .copyWith(fontSize: GlobalSize.dateFont1),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ~:Batal:~
                    Container(
                      width: 80,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.red[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      child: Column(
                        children: [
                          Container(
                            height: 32,
                            alignment: Alignment.center,
                            child: Text(
                              'Batal',
                              style: GlobalFont.mediumbigfontR.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              state.salesData[0].batal.toString(),
                              style: GlobalFont.giantfontRBold
                                  .copyWith(fontSize: GlobalSize.dateFont1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ~:New Prospect Progress Bar:~
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: LinearProgressIndicator(
                      value: state.salesData[0].newProspect.toDouble() /
                          state.salesData[0].totalProspect.toDouble(),
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation(Colors.blue[200]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Prospek Baru: ${state.salesData[0].newProspect.toString()} orang (${state.salesData[0].persenNew.toString()}%)',
                      style: GlobalFont.mediumbigfontR,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
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
