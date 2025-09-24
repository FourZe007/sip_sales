// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales/global/enum.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state/dashboard_slidingup_cubit.dart';
import 'package:sip_sales/global/state/dashboardtype_cubit.dart';
import 'package:sip_sales/global/state/followupdashboard/followup_dashboard_bloc.dart';
import 'package:sip_sales/global/state/followupdashboard/followup_dashboard_event.dart';
import 'package:sip_sales/global/state/fufiltercontrols_cubit.dart';
import 'package:sip_sales/global/state/login/login_bloc.dart';
import 'package:sip_sales/global/state/login/login_state.dart';
import 'package:sip_sales/global/state/provider.dart';
import 'package:sip_sales/global/state/salesdashboard/sales_dashboard_bloc.dart';
import 'package:sip_sales/global/state/salesdashboard/sales_dashboard_event.dart';
import 'package:sip_sales/pages/screen/followup_dashboard.dart';
import 'package:sip_sales/pages/screen/followup_deal_dashboard.dart';
import 'package:sip_sales/pages/screen/salesman_dashboard.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  FollowUpStatus dataTypeLabel = FollowUpStatus.notYet;
  final PanelController slidingPanelController = PanelController();

  void refreshDashboard(
    BuildContext context,
    SipSalesState appState,
    LoginState loginState,
    DashboardType state, {
    bool sortByName = false,
  }) {
    // appState.getUserAccountList.isNotEmpty
    //     ? appState.getUserAccountList[0].employeeID
    //     : ''
    final salesmanId =
        (loginState is LoginSuccess && loginState.user[0].code == 2)
            ? (ModalRoute.of(context)?.settings.arguments
                as Map<String, dynamic>)['salesmanId']
            : (loginState as LoginSuccess).user[0].employeeID;
    final date = DateTime.now().toIso8601String().substring(0, 10);

    if (state.name == 'salesman') {
      print('Dashboard type: salesman');
      context
          .read<SalesDashboardBloc>()
          .add(LoadSalesDashboard(salesmanId, date));
    } else if (state.name == 'followup') {
      print('Dashboard type: followup');
      // context.read<FuFilterControlsCubit>().resetFilters();
      context.read<FuFilterControlsCubit>().toggleFilter('sortByName', false);

      final activeFilters =
          context.read<FuFilterControlsCubit>().state.activeFilters;
      if (activeFilters['notFollowedUp'] == true) {
        print('notFollowedUp');
        context.read<FollowupDashboardBloc>().add(
              LoadFollowupDashboard(salesmanId, date, sortByName),
            );
      } else if (activeFilters['deal'] == true) {
        print('deal');
        context.read<FollowupDashboardBloc>().add(
              LoadFollowupDealDashboard(salesmanId, date, sortByName),
            );
      }
    }
  }

  void openLink(
    BuildContext context,
    String url,
  ) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Tidak dapat membuka tautan.');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.grey,
            content: Text(
              'Tidak dapat membuka tautan.',
              style: GlobalFont.bigfontR,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.all(8),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void valueOnChanged(
    BuildContext context,
    SipSalesState appState,
    FollowUpStatus? newValue, {
    bool sortByName = false,
  }) async {
    if (newValue != null) {
      context.read<DashboardSlidingUpCubit>().closePanel();
      if (newValue == FollowUpStatus.notYet) {
        context.read<FuFilterControlsCubit>().toggleFilter(
              'notFollowedUp',
              true,
            );
      } else if (newValue == FollowUpStatus.completed) {
        context.read<FuFilterControlsCubit>().toggleFilter(
              'deal',
              true,
            );
      }

      context.read<FuFilterControlsCubit>().toggleFilter(
            'sortByName',
            sortByName,
          );

      refreshDashboard(
        context,
        appState,
        context.read<LoginBloc>().state,
        DashboardType.followup,
        sortByName: sortByName,
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
      maintainBottomViewPadding: true,
      child: DefaultTabController(
        length: 2,
        initialIndex: context.read<DashboardTypeCubit>().state.index,
        animationDuration: Duration(milliseconds: 500),
        child: SlidingUpPanel(
          controller: slidingPanelController,
          backdropEnabled: true,
          backdropColor: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20.0),
          minHeight: 0.0,
          maxHeight: 175,
          defaultPanelState: PanelState.CLOSED,
          onPanelClosed: () =>
              context.read<DashboardSlidingUpCubit>().closePanel(),
          panel: Material(
            color: Colors.transparent,
            child: Container(
              height: 175,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                spacing: 4,
                children: [
                  // Draggable handle
                  Container(
                    width: 60,
                    height: 8,
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  // ~:Content:~
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: BlocBuilder<DashboardSlidingUpCubit,
                          DashboardSlidingUpState>(
                        builder: (context, state) {
                          if (state.type ==
                              DashboardSlidingUpType.followupfilter) {
                            return Column(
                              spacing: 12,
                              children: [
                                // ~:Filter Title:~
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Filter',
                                    style: GlobalFont.bigfontR.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                // ~:1st Filter:~
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  child: Row(
                                    spacing: 12,
                                    children: [
                                      // ~:Title:~
                                      Expanded(child: Text('Tipe Data')),

                                      // ~:Dropdown:~
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            border: Border.all(
                                              color: Colors.blue,
                                              width: 1.5,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical: 4.0,
                                          ),
                                          child: BlocBuilder<
                                                  FuFilterControlsCubit,
                                                  FuFilterControlsState>(
                                              builder: (context, state) {
                                            return DropdownButton(
                                              value: state.activeFilters[
                                                          'notFollowedUp'] ==
                                                      true
                                                  ? FollowUpStatus.notYet
                                                  : FollowUpStatus.completed,
                                              onChanged: (newValue) =>
                                                  valueOnChanged(
                                                context,
                                                appState,
                                                newValue,
                                              ),
                                              isExpanded: true,
                                              dropdownColor: Colors.white,
                                              icon: const Icon(
                                                Icons.arrow_drop_down_rounded,
                                                color: Colors.blue,
                                              ),
                                              iconSize: 28,
                                              elevation: 4,
                                              style: GlobalFont.bigfontR,
                                              underline: SizedBox(),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              items: FollowUpStatus.values
                                                  .where((element) =>
                                                      element ==
                                                          FollowUpStatus
                                                              .notYet ||
                                                      element ==
                                                          FollowUpStatus
                                                              .completed)
                                                  .map((FollowUpStatus value) {
                                                switch (value) {
                                                  case FollowUpStatus.notYet:
                                                    return DropdownMenuItem<
                                                        FollowUpStatus>(
                                                      value:
                                                          FollowUpStatus.notYet,
                                                      child: Text(
                                                          'Belum Follow Up'),
                                                    );
                                                  case FollowUpStatus.completed:
                                                    return DropdownMenuItem<
                                                        FollowUpStatus>(
                                                      value: FollowUpStatus
                                                          .completed,
                                                      child: Text('Deal'),
                                                    );
                                                  default:
                                                    return DropdownMenuItem<
                                                        FollowUpStatus>(
                                                      value:
                                                          FollowUpStatus.notYet,
                                                      child: Text(
                                                          'Belum Follow Up'),
                                                    );
                                                }
                                              }).toList(),
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // ~:2nd Filter:~
                                // Bug: The switch is not properly changed when the switch is toggled
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      // ~:Title:~
                                      Expanded(child: Text('Sort names A-Z')),

                                      // ~:Switch:~
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: BlocBuilder<
                                              FuFilterControlsCubit,
                                              FuFilterControlsState>(
                                            builder: (context, state) {
                                              print(
                                                  'isSortByName active: ${state.activeFilters['sortByName']!}');
                                              return CupertinoSwitch(
                                                value: state.activeFilters[
                                                        'sortByName'] ??
                                                    false,
                                                onChanged: (value) =>
                                                    valueOnChanged(
                                                  context,
                                                  appState,
                                                  state.activeFilters[
                                                              'notFollowedUp'] ==
                                                          true
                                                      ? FollowUpStatus.notYet
                                                      : FollowUpStatus
                                                          .completed,
                                                  sortByName: value,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else if (state.type ==
                              DashboardSlidingUpType.moreoption) {
                            return Column(
                              spacing: 8,
                              children: [
                                // ~:Title:~
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Quick Action',
                                    style: GlobalFont.bigfontR.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                // ~:CTA WhatsApp:~
                                ElevatedButton.icon(
                                  onPressed: () async => openLink(
                                    context,
                                    'https://wa.me/62${state.optionalData.replaceFirst('0', '')}',
                                  ),
                                  icon: Icon(
                                    FontAwesomeIcons.whatsapp,
                                    color: Colors.black,
                                  ),
                                  label: Text(
                                    'Hubungi via WhatsApp',
                                    style: GlobalFont.bigfontR,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(
                                      MediaQuery.of(context).size.width,
                                      40,
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
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: BlocListener<DashboardSlidingUpCubit, DashboardSlidingUpState>(
            listener: (context, state) {
              if (state.type == DashboardSlidingUpType.followupfilter ||
                  state.type == DashboardSlidingUpType.moreoption) {
                print('Opening Sliding Up Panel - State: $state');
                slidingPanelController.open();
              } else {
                print('Closing Sliding Up Panel - State: $state');
                slidingPanelController.close();
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  'Laporan Penjualan',
                  style: GlobalFont.bigfontR,
                ),
                backgroundColor: Colors.blue,
                leading: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Platform.isIOS
                          ? Icons.arrow_back_ios_new_rounded
                          : Icons.arrow_back_rounded,
                      size: (MediaQuery.of(context).size.width < 800)
                          ? 20.0
                          : 35.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                actions: [
                  BlocBuilder<DashboardTypeCubit, DashboardType>(
                      builder: (context, state) {
                    return IconButton(
                      onPressed: () => refreshDashboard(
                        context,
                        appState,
                        context.read<LoginBloc>().state,
                        state,
                      ),
                      icon: Icon(
                        Icons.refresh_rounded,
                        size: (MediaQuery.of(context).size.width < 800)
                            ? 20.0
                            : 35.0,
                        color: Colors.black,
                      ),
                    );
                  }),
                ],
                bottom: TabBar(
                  onTap: (index) {
                    print('Index: ${index.toString()}');
                    print(context
                        .read<FuFilterControlsCubit>()
                        .state
                        .activeFilters
                        .toString());
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
                    Tab(text: 'Dashboard'),
                    Tab(text: 'Follow-Up'),
                  ],
                ),
              ),
              body: BlocListener<DashboardTypeCubit, DashboardType>(
                listener: (context, state) => refreshDashboard(
                  context,
                  appState,
                  context.read<LoginBloc>().state,
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
                        BlocBuilder<FuFilterControlsCubit,
                            FuFilterControlsState>(
                          builder: (context, state) {
                            if (state.activeFilters['notFollowedUp'] == true) {
                              return FollowupDashboard();
                            } else if (state.activeFilters['deal'] == true) {
                              return FollowupDealDashboard();
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
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
