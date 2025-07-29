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

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<SipSalesState>(context);
    late TabController tabController;

    return SafeArea(
      top: false,
      bottom: false,
      left: false,
      right: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SlidingUpPanel(
          controller: panelController,
          minHeight: 0,
          maxHeight: 100,
          isDraggable: false,
          panelSnapping: false,
          defaultPanelState: PanelState.CLOSED,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          backdropEnabled: true,
          backdropColor: Colors.grey[800]!,
          panel: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ~:Filter Title:~
                Text('Pilih Jenis Dashboard'),

                // ~:Filter Dropdown:~
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey[300]!,
                      ),
                    ),
                    child: BlocBuilder<DashboardTypeCubit, DashboardType>(
                        builder: (context, state) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton<DashboardType>(
                          value: state,
                          onChanged: (value) {
                            context
                                .read<DashboardTypeCubit>()
                                .changeType(value!);

                            panelController.close();
                          },
                          items: DashboardType.values.map((e) {
                            if (e == DashboardType.followup) {
                              return DropdownMenuItem<DashboardType>(
                                value: e,
                                child: Text(
                                  'Follow-Up',
                                ),
                              );
                            }

                            return DropdownMenuItem<DashboardType>(
                              value: e,
                              child: Text(
                                e.name[0].toUpperCase() + e.name.substring(1),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          body: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  'Dashboard',
                  style: GlobalFont.bigfontR,
                ),
                // title: BlocBuilder<DashboardTypeCubit, DashboardType>(
                //   builder: (context, state) {
                //     String name = state.name;
                //     if (name == 'followup') {
                //       name = 'Follow-Up';
                //     }
                //
                //     if (MediaQuery.of(context).size.width < 800) {
                //       return Text(
                //         'Dashboard ${name[0].toUpperCase()}${name.substring(1)}',
                //         style: GlobalFont.bigfontRBold,
                //       );
                //     } else {
                //       return Text(
                //         'Dashboard ${name[0].toUpperCase()}${name.substring(1)}',
                //         style: GlobalFont.bigfontRBold.copyWith(fontSize: 20),
                //       );
                //     }
                //   },
                // ),
                backgroundColor: Colors.blue,
                leading: Builder(
                  builder: (context) {
                    if (Platform.isIOS) {
                      return IconButton(
                        onPressed: () {
                          context
                              .read<DashboardTypeCubit>()
                              .changeType(DashboardType.salesman);

                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: (MediaQuery.of(context).size.width < 800)
                              ? 20.0
                              : 35.0,
                          color: Colors.black,
                        ),
                      );
                    } else {
                      return IconButton(
                        onPressed: () {
                          context
                              .read<DashboardTypeCubit>()
                              .changeType(DashboardType.salesman);

                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          size: (MediaQuery.of(context).size.width < 800)
                              ? 20.0
                              : 35.0,
                          color: Colors.black,
                        ),
                      );
                    }
                  },
                ),
                actions: [
                  IconButton(
                    onPressed: () => panelController.open(),
                    icon: Icon(
                      Icons.filter_alt,
                      size: (MediaQuery.of(context).size.width < 800)
                          ? 25.0
                          : 40.0,
                      color: Colors.black,
                    ),
                  ),
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
                listener: (context, state) {
                  log('Dashboard Type: ${state.name}');
                  final salesmanId = appState.getUserAccountList.isNotEmpty
                      ? appState.getUserAccountList[0].employeeID
                      : '';
                  final date =
                      DateTime.now().toIso8601String().substring(0, 10);

                  if (state.name == 'salesman') {
                    context.read<SalesDashboardBloc>().add(
                          LoadSalesDashboard(salesmanId, date),
                        );
                  } else if (state.name == 'followup') {
                    context.read<FollowupDashboardBloc>().add(
                          LoadFollowupDashboard(salesmanId, date),
                        );
                  }
                },
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
                    padding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // ~:Salesman:~
                        SalesmanDashboard(),

                        // ~:Follow-Up:~
                        FollowupDashboard(),

                        // DecoratedBox(
                        //   decoration: BoxDecoration(
                        //     color: Colors.blue,
                        //   ),
                        //   child: Container(
                        //     height: MediaQuery.of(context).size.height,
                        //     width: MediaQuery.of(context).size.width,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.only(
                        //         topLeft: Radius.circular(20.0),
                        //         topRight: Radius.circular(20.0),
                        //       ),
                        //       color: Colors.white,
                        //     ),
                        //     padding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                        //     child: BlocConsumer<DashboardTypeCubit, DashboardType>(
                        //       listener: (context, state) {
                        //         log('Dashboard Type: ${state.name}');
                        //         final salesmanId =
                        //             appState.getUserAccountList.isNotEmpty
                        //                 ? appState.getUserAccountList[0].employeeID
                        //                 : '';
                        //         final date =
                        //             DateTime.now().toIso8601String().substring(0, 10);
                        //
                        //         if (state.name == 'salesman') {
                        //           context.read<SalesDashboardBloc>().add(
                        //                 LoadSalesDashboard(salesmanId, date),
                        //               );
                        //         } else if (state.name == 'followup') {
                        //           context.read<FollowupDashboardBloc>().add(
                        //                 LoadFollowupDashboard(salesmanId, date),
                        //               );
                        //         }
                        //       },
                        //       builder: (context, state) {
                        //         if (state.name == 'salesman') {
                        //           return SalesmanDashboard();
                        //         } else if (state.name == 'followup') {
                        //           return FollowupDashboard();
                        //         } else {
                        //           return Center(
                        //             child: Text('No filter selected'),
                        //           );
                        //         }
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
