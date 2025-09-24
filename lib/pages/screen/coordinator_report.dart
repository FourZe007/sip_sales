import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/state/coordinatordashboard/coord_dashboard_bloc.dart';
import 'package:sip_sales/global/state/coordinatordashboard/coord_dashboard_event.dart';
import 'package:sip_sales/global/state/provider.dart';
import 'package:sip_sales/pages/screen/coordinator_dashboard.dart';

class CoordinatorReport extends StatefulWidget {
  const CoordinatorReport({super.key});

  @override
  State<CoordinatorReport> createState() => _CoordinatorReportState();
}

class _CoordinatorReportState extends State<CoordinatorReport> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.025,
        MediaQuery.of(context).size.height * 0.02,
        MediaQuery.of(context).size.width * 0.025,
        0,
      ),
      child: (Platform.isIOS)
          ? CustomScrollView(
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () async =>
                      context.read<CoordinatorDashboardBloc>().add(
                            LoadCoordinatorDashboard(
                              await Provider.of<SipSalesState>(context,
                                      listen: false)
                                  .readAndWriteUserId(),
                              DateTime.now().toIso8601String().split('T')[0],
                            ),
                          ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, _) => CoordinatorDashboard(),
                    childCount: 1,
                  ),
                ),
              ],
            )
          : RefreshIndicator(
              onRefresh: () async => context
                  .read<CoordinatorDashboardBloc>()
                  .add(
                    LoadCoordinatorDashboard(
                      await Provider.of<SipSalesState>(context, listen: false)
                          .readAndWriteUserId(),
                      DateTime.now().toIso8601String().split('T')[0],
                    ),
                  ),
              child: CoordinatorDashboard(),
            ),
    );
  }
}
