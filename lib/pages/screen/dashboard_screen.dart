import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/enum.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state/dashboardtype_cubit.dart';
import 'package:sip_sales/global/state/followupdashboard/followup_dashboard_bloc.dart';
import 'package:sip_sales/global/state/followupdashboard/followup_dashboard_event.dart';
import 'package:sip_sales/global/state/provider.dart';
import 'package:sip_sales/global/state/salesdashboard/sales_dashboard_bloc.dart';
import 'package:sip_sales/global/state/salesdashboard/sales_dashboard_event.dart';
import 'package:sip_sales/pages/screen/followup_dashboard.dart';
import 'package:sip_sales/pages/screen/salesman_dashboard.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PanelController panelController = PanelController();

  void refreshDashboard(
    BuildContext context,
    SipSalesState appState,
    DashboardType state,
  ) {
    final salesmanId = appState.getUserAccountList.isNotEmpty
        ? appState.getUserAccountList[0].employeeID
        : '';
    final date = DateTime.now().toIso8601String().substring(0, 10);

    if (state.name == 'salesman') {
      context.read<SalesDashboardBloc>().add(
            LoadSalesDashboard(salesmanId, date),
          );
    } else if (state.name == 'followup') {
      context.read<FollowupDashboardBloc>().add(
            LoadFollowupDashboard(salesmanId, date),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<SipSalesState>(context);
    // late TabController tabController;

    return SafeArea(
      top: false,
      bottom: false,
      left: false,
      right: false,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Dashboard',
              style: GlobalFont.bigfontR,
            ),
            backgroundColor: Colors.blue,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Platform.isIOS
                    ? Icons.arrow_back_ios_new_rounded
                    : Icons.arrow_back_rounded,
                size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                color: Colors.black,
              ),
            ),
            actions: [
              BlocBuilder<DashboardTypeCubit, DashboardType>(
                  builder: (context, state) {
                return IconButton(
                  onPressed: () => refreshDashboard(context, appState, state),
                  icon: Icon(
                    Icons.refresh_rounded,
                    size:
                        (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                    color: Colors.black,
                  ),
                );
              }),
            ],
            bottom: TabBar(
              onTap: (index) {
                log('Index: ${index.toString()}');
                context.read<DashboardTypeCubit>().changeType(index == 0
                    ? DashboardType.salesman
                    : DashboardType.followup);
              },
              indicatorColor: Colors.black,
              indicatorWeight: 2,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              unselectedLabelStyle: GlobalFont.bigfontR,
              labelStyle: GlobalFont.bigfontR.copyWith(
                fontWeight: FontWeight.bold,
              ),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: 'Salesman'),
                Tab(text: 'Follow-Up'),
              ],
            ),
          ),
          body: BlocListener<DashboardTypeCubit, DashboardType>(
            listener: (context, state) => refreshDashboard(
              context,
              appState,
              state,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  color: Colors.white,
                ),
                padding: EdgeInsets.fromLTRB(12, 16, 12, 8),
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // ~:Salesman:~
                    SalesmanDashboard(),

                    // ~:Follow-Up:~
                    FollowupDashboard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
