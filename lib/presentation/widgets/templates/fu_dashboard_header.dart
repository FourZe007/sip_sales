import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/core/constant/enum.dart';
import 'package:sip_sales_clean/data/models/fu_dashboard.dart';
import 'package:sip_sales_clean/presentation/cubit/dashboard_slidingup_cubit.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/templates/widgets.dart';

class FuDashboardHeader extends StatelessWidget {
  const FuDashboardHeader({
    super.key,
    this.defaultVerticalSpacing = 8,
    this.defaultHorizontalSpacing = 2,
    required this.isFuDeal,
    this.fuData,
    this.fuDealData,
  });

  final double defaultVerticalSpacing;
  final double defaultHorizontalSpacing;
  final bool isFuDeal;
  final FollowUpDashboardModel? fuData;
  final FollowUpDealDashboardModel? fuDealData;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: defaultVerticalSpacing,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ~:Data:~
        Row(
          spacing: defaultHorizontalSpacing,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // ~:Total Prospek:~
            Expanded(
              child: Widgets.buildStatBox(
                context: context,
                label: 'Prospek',
                value: isFuDeal
                    ? '${fuDealData!.totalProspect}'
                    : '${fuData!.totalProspect}',
                boxWidth: 64,
                boxHeight: 90,
                labelHeight: 28,
                labelSize: 12,
                boxColor: Colors.blue[200]!,
              ),
            ),

            // ~:Belum Follow-Up:~
            Expanded(
              child: Widgets.buildStatBox(
                context: context,
                label: 'Belum FU',
                value: isFuDeal
                    ? '${fuDealData!.belumFU}'
                    : '${fuData!.belumFU}',
                boxWidth: 64,
                boxHeight: 90,
                labelHeight: 28,
                labelSize: 12,
                boxColor: Colors.grey[400]!,
              ),
            ),

            // ~:Proses Follow-Up:~
            Expanded(
              child: Widgets.buildStatBox(
                context: context,
                label: 'Proses FU',
                value: isFuDeal
                    ? '${fuDealData!.prosesFU}'
                    : '${fuData!.prosesFU}',
                boxWidth: 64,
                boxHeight: 90,
                labelHeight: 28,
                labelSize: 12,
                boxColor: Colors.yellow[300]!,
              ),
            ),

            // ~:Closing:~
            Expanded(
              child: Widgets.buildStatBox(
                context: context,
                label: 'Deal',
                value: isFuDeal
                    ? '${fuDealData!.closing}'
                    : '${fuData!.closing}',
                boxWidth: 64,
                boxHeight: 90,
                labelHeight: 28,
                labelSize: 12,
                boxColor: Colors.green[300]!,
              ),
            ),

            // ~:Batal:~
            Expanded(
              child: Widgets.buildStatBox(
                context: context,
                label: 'Batal',
                value: isFuDeal ? '${fuDealData!.batal}' : '${fuData!.batal}',
                boxWidth: 64,
                boxHeight: 90,
                labelHeight: 28,
                labelSize: 12,
                boxColor: Colors.red[300]!,
              ),
            ),
          ],
        ),

        // ~:Progress Bar & Filter Controls:~
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            spacing: 4,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ~:New Prospect Progress Bar:~
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: LinearProgressIndicator(
                        value: isFuDeal
                            ? fuDealData!.newProspect.toDouble() /
                                  fuDealData!.totalProspect.toDouble()
                            : fuData!.newProspect.toDouble() /
                                  fuData!.totalProspect.toDouble(),
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation(Colors.blue[200]),
                        borderRadius: BorderRadius.circular(20),
                        stopIndicatorRadius: 20,
                      ),
                    ),
                    Center(
                      child: Text(
                        'Prospek Baru: ${isFuDeal ? fuDealData!.newProspect.toString() : fuData!.newProspect.toString()} orang (${isFuDeal ? fuDealData!.persenNew.toString() : fuData!.persenNew.toString()}%)',
                        style: TextThemes.normal,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              // ~:Filter Controls:~
              IconButton(
                onPressed: () {
                  log('Filter Button pressed');
                  context.read<DashboardSlidingUpCubit>().changeType(
                    DashboardSlidingUpType.followupfilter,
                  );
                },
                constraints: BoxConstraints(),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Colors.grey[300],
                  ),
                  shape: WidgetStatePropertyAll(CircleBorder()),
                ),
                icon: Icon(Icons.filter_alt_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
