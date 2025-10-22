import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:sip_sales_clean/core/constant/enum.dart';
import 'package:sip_sales_clean/presentation/blocs/followup/fu_dashboard_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/followup/fu_dashboard_event.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_state.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman/salesman_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman/salesman_event.dart';
import 'package:sip_sales_clean/presentation/blocs/shop_coordinator/shop_coordinator_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/shop_coordinator/shop_coordinator_event.dart';
import 'package:sip_sales_clean/presentation/cubit/dashboard_type.dart';
import 'package:sip_sales_clean/presentation/cubit/fu_controls_cubit.dart';
import 'package:sip_sales_clean/presentation/screens/coordinator_screen.dart';
import 'package:sip_sales_clean/presentation/screens/sales_report_screen.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/datagrids/leasing_condition.dart';
import 'package:sip_sales_clean/presentation/widgets/datagrids/sales_category.dart';
import 'package:sip_sales_clean/presentation/widgets/datagrids/salesman_followup.dart';
import 'package:sip_sales_clean/presentation/widgets/datagrids/salesman_prospek.dart';
import 'package:sip_sales_clean/presentation/widgets/datagrids/salesman_stu.dart';
import 'package:sip_sales_clean/presentation/widgets/graphs/db_stu.dart';
import 'package:sip_sales_clean/presentation/widgets/graphs/prospek_stu.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/templates/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class HeadDashboardScreen extends StatefulWidget {
  const HeadDashboardScreen({super.key});

  @override
  State<HeadDashboardScreen> createState() => _HeadDashboardScreenState();
}

class _HeadDashboardScreenState extends State<HeadDashboardScreen> {
  void onProspectCellTap(
    BuildContext context,
    HeadStoreState state,
    DataGridCellTapDetails details,
  ) {
    if (details.rowColumnIndex.rowIndex > 0) {
      int selectedIndex = details.rowColumnIndex.rowIndex - 1;
      var rowData = (state as HeadStoreDashboardLoaded)
          .headStoreDashboard[0]
          .prospekList[selectedIndex];

      if (rowData.employeeType!.toLowerCase() == 's') {
        context.read<DashboardTypeCubit>().changeType(DashboardType.salesman);

        context.read<FuFilterControlsCubit>().resetFilters();

        context.read<SalesmanBloc>().add(
          SalesmanDashboardButtonPressed(
            salesmanId: rowData.employeeId,
            endDate: DateFormat(
              'yyyy-MM-dd',
            ).format(DateTime.now()),
          ),
        );

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalesReportScreen(
                salesmanId: rowData.employeeId,
              ),
            ),
          );
        }
      } else {
        context.read<ShopCoordinatorBloc>().add(
          LoadCoordinatorDashboard(
            rowData.employeeId,
            DateTime.now().toIso8601String().split(
              'T',
            )[0],
          ),
        );

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoordinatorScreen(
                employeeId: rowData.employeeId,
                applyUserProfile: true,
              ),
            ),
          );
        }
      }
    }
  }

  void onFUCellTap(
    BuildContext context,
    HeadStoreState state,
    DataGridCellTapDetails details,
  ) {
    if (details.rowColumnIndex.rowIndex > 0) {
      int selectedIndex = details.rowColumnIndex.rowIndex - 1;
      var rowData = (state as HeadStoreDashboardLoaded)
          .headStoreDashboard[0]
          .salesFUOverviewList[selectedIndex];

      if (rowData.employeeType!.toLowerCase() == 's') {
        context.read<DashboardTypeCubit>().changeType(DashboardType.followup);

        context.read<FuFilterControlsCubit>().resetFilters();

        context.read<FollowupDashboardBloc>().add(
          LoadFollowupDashboard(
            rowData.employeeId,
            DateFormat(
              'yyyy-MM-dd',
            ).format(DateTime.now()),
            false,
          ),
        );

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalesReportScreen(
                salesmanId: rowData.employeeId,
              ),
            ),
          );
        }
      } else {
        context.read<ShopCoordinatorBloc>().add(
          LoadCoordinatorDashboard(
            rowData.employeeId,
            DateTime.now().toIso8601String().split(
              'T',
            )[0],
          ),
        );

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoordinatorScreen(
                employeeId: rowData.employeeId,
                applyUserProfile: true,
              ),
            ),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    initializeDateFormatting('id_ID', null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        20,
        16,
        // (Platform.isIOS) ? 8 : 16,
        0,
      ),
      child: BlocBuilder<HeadStoreBloc, HeadStoreState>(
        buildWhen: (previous, current) =>
            (current is HeadStoreLoading && current.isDashboard) ||
            current is HeadStoreDashboardLoaded ||
            current is HeadStoreDashboardFailed,
        builder: (context, state) {
          log(state.toString());
          if (state is HeadStoreLoading && state.isDashboard) {
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
          } else if (state is HeadStoreDashboardFailed) {
            return Center(
              child: Text(
                state.message,
                textAlign: TextAlign.center,
              ),
            );
          } else if (state is HeadStoreDashboardLoaded) {
            log('Head Store length: ${state.headStoreDashboard.length}');

            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: state.headStoreDashboard.length,
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 8.0),
                itemBuilder: (context, index) {
                  final headDashboardData = state.headStoreDashboard[index];
                  double salesProspectHeight =
                      52 + headDashboardData.prospekList.length * 50;
                  double salesFUOverviewHeight =
                      52 + headDashboardData.salesFUOverviewList.length * 50;
                  double salesStuHeight =
                      52 + headDashboardData.stuList.length * 50;
                  double categoryHeight =
                      52 + headDashboardData.categoryList.length * 50;
                  double leasingHeight =
                      52 + headDashboardData.leasingList.length * 50;

                  return Column(
                    spacing: 12,
                    children: [
                      // ~:Hasil Akumulasi:~
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          spacing: 8,
                          children: [
                            // ~:Title:~
                            Row(
                              spacing: 4,
                              children: [
                                Text(
                                  'Hasil Akumulasi,',
                                  style: TextThemes.normal.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Builder(
                                  builder: (context) {
                                    DateTime now = DateTime.now();
                                    String formattedDate;

                                    if (now.day == 1) {
                                      formattedDate = DateFormat(
                                        'dd MMMM yyyy',
                                        'id_ID',
                                      ).format(now);
                                    } else {
                                      formattedDate =
                                          '01 - ${DateFormat('dd MMMM yyyy', 'id_ID').format(now)}';
                                    }

                                    return Text(
                                      formattedDate,
                                      style: TextThemes.normal.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),

                            // ~:Data:~
                            Row(
                              spacing: 4,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // ~:Prospek:~
                                Expanded(
                                  child: Widgets.buildStatBox(
                                    context: context,
                                    label: 'Prospek',
                                    value: headDashboardData.prospek,
                                    labelSize: 12,
                                  ),
                                ),

                                // ~:SPK:~
                                Expanded(
                                  child: Widgets.buildStatBox(
                                    context: context,
                                    label: 'SPK',
                                    value: headDashboardData.spk,
                                    labelSize: 12,
                                  ),
                                ),

                                // ~:SPK Terbuka:~
                                Expanded(
                                  child: Widgets.buildStatBox(
                                    context: context,
                                    label: 'Terbuka',
                                    value: headDashboardData.spkTerbuka,
                                    labelSize: 12,
                                  ),
                                ),

                                // ~:STU:~
                                Expanded(
                                  child: Widgets.buildStatBox(
                                    context: context,
                                    label: 'STU',
                                    value: headDashboardData.stu,
                                    labelSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // ~:Harian:~
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ~:Title & Date:~
                            Row(
                              spacing: 4,
                              children: [
                                // ~:Title:~
                                Text(
                                  'Hasil hari ${DateFormat('EEEE', 'id_ID').format(DateTime.now())},',
                                  style: TextThemes.normal.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                // ~:Date:~
                                Text(
                                  DateFormat(
                                    'dd MMMM yyyy',
                                    'id_ID',
                                  ).format(DateTime.now()),
                                  style: TextThemes.normal.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            // ~:Data:~
                            Row(
                              spacing: 4,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // ~:Prospek:~
                                Expanded(
                                  child: Widgets.buildStatBox(
                                    context: context,
                                    label: 'Prospek',
                                    value: headDashboardData.prospekH,
                                    boxWidth: 80,
                                    boxHeight: 75,
                                    labelSize: 12,
                                    boxColor: Colors.green[200]!,
                                  ),
                                ),

                                // ~:SPK:~
                                Expanded(
                                  child: Widgets.buildStatBox(
                                    context: context,
                                    label: 'SPK',
                                    value: headDashboardData.spkh,
                                    boxWidth: 80,
                                    boxHeight: 75,
                                    labelSize: 12,
                                    boxColor: Colors.green[200]!,
                                  ),
                                ),

                                // ~:SPK Terbuka:~
                                Expanded(
                                  child: Widgets.buildStatBox(
                                    context: context,
                                    label: 'Terbuka',
                                    value: headDashboardData.spkTerbukaH,
                                    boxWidth: 80,
                                    boxHeight: 75,
                                    labelSize: 12,
                                    boxColor: Colors.green[200]!,
                                  ),
                                ),

                                // ~:STU:~
                                Expanded(
                                  child: Widgets.buildStatBox(
                                    context: context,
                                    label: 'STU',
                                    value: headDashboardData.stuh,
                                    boxWidth: 80,
                                    boxHeight: 75,
                                    labelSize: 12,
                                    boxColor: Colors.green[200]!,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // ~:Coordinator Prospect:~
                      Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            spacing: 8,
                            children: [
                              // ~:Title:~
                              Text(
                                'Prospek Koordinator',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // ~:Table:~
                              Container(
                                height: salesProspectHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: SfDataGrid(
                                  source: SalesmanProspekDataSource(
                                    context: context,
                                    salesmanProspekData:
                                        state.headStoreDashboard[0].prospekList,
                                  ),
                                  onCellTap: (details) => onProspectCellTap(
                                    context,
                                    state,
                                    details,
                                  ),
                                  columnWidthMode: ColumnWidthMode.fill,
                                  horizontalScrollPhysics:
                                      NeverScrollableScrollPhysics(),
                                  verticalScrollPhysics:
                                      NeverScrollableScrollPhysics(),
                                  columns: [
                                    GridColumn(
                                      columnName: 'salesman',
                                      minimumWidth: 80,
                                      label: Align(
                                        alignment: Alignment.center,
                                        child: Text('Nama'),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'targetProspek',
                                      minimumWidth: 56,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Target Prospek',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'prospek',
                                      minimumWidth: 32,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Prospek'),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'targetSPK',
                                      minimumWidth: 32,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Target SPK',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'spk',
                                      minimumWidth: 40,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('SPK'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ~:Coordinator Follow-Up:~
                      Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            spacing: 8,
                            children: [
                              // ~:Title:~
                              Text(
                                'Follow-Up Koordinator',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // ~:Table:~
                              Container(
                                height: salesFUOverviewHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: SfDataGrid(
                                  source: SalesFUOverviewDataSource(
                                    context: context,
                                    salesFUOverviewData: state
                                        .headStoreDashboard[0]
                                        .salesFUOverviewList,
                                  ),
                                  onCellTap: (details) =>
                                      onFUCellTap(context, state, details),
                                  columnWidthMode: ColumnWidthMode.fill,
                                  horizontalScrollPhysics:
                                      const NeverScrollableScrollPhysics(),
                                  verticalScrollPhysics:
                                      const NeverScrollableScrollPhysics(),
                                  columns: [
                                    GridColumn(
                                      columnName: 'salesman',
                                      minimumWidth: 80,
                                      label: const Align(
                                        alignment: Alignment.center,
                                        child: Text('Nama'),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'prosesFU',
                                      minimumWidth: 56,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Proses FU',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'closing',
                                      minimumWidth: 32,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: const Text('Closing'),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'cancel',
                                      minimumWidth: 24,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Batal',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'blmFU',
                                      minimumWidth: 40,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Belum FU',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ~:Coordinator STU:~
                      Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            spacing: 8,
                            children: [
                              // ~:Title:~
                              Text(
                                'STU Koordinator',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // ~:Table:~
                              Container(
                                height: salesStuHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: SfDataGrid(
                                  source: SalesmanSTUDataSource(
                                    salesmanSTUData:
                                        state.headStoreDashboard[0].stuList,
                                  ),
                                  columnWidthMode: ColumnWidthMode.fill,
                                  horizontalScrollPhysics:
                                      NeverScrollableScrollPhysics(),
                                  verticalScrollPhysics:
                                      NeverScrollableScrollPhysics(),
                                  columns: [
                                    GridColumn(
                                      columnName: 'salesman',
                                      minimumWidth: 80,
                                      label: Align(
                                        alignment: Alignment.center,
                                        child: Text('Nama'),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'targetStu',
                                      minimumWidth: 56,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Target STU',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'stu',
                                      minimumWidth: 32,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('STU'),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'stuLm',
                                      minimumWidth: 32,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'STU LM',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: '%',
                                      minimumWidth: 40,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('%'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ~:Sales per Category:~
                      Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            spacing: 8,
                            children: [
                              // ~:Title:~
                              Text(
                                'Penjualan per Kategori',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // ~:Table:~
                              Container(
                                height: categoryHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: SfDataGrid(
                                  source: SalesCategoryDataSource(
                                    categoryData: state
                                        .headStoreDashboard[0]
                                        .categoryList,
                                  ),
                                  columnWidthMode: ColumnWidthMode.fill,
                                  horizontalScrollPhysics:
                                      NeverScrollableScrollPhysics(),
                                  verticalScrollPhysics:
                                      NeverScrollableScrollPhysics(),
                                  columns: [
                                    GridColumn(
                                      columnName: 'method',
                                      minimumWidth: 68,
                                      label: Align(
                                        alignment: Alignment.center,
                                        child: Text(''),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'pros',
                                      minimumWidth: 56,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Prospek'),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'spk',
                                      minimumWidth: 32,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('SPK'),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'stu',
                                      minimumWidth: 32,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('STU'),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'lm',
                                      minimumWidth: 50,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('STU BL'),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: '%',
                                      minimumWidth: 68,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('% Grow'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ~:Leasing Condition:~
                      Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            spacing: 8,
                            children: [
                              // ~:Title:~
                              Text(
                                'Kondisi Leasing',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // ~:Table:~
                              Container(
                                height: leasingHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: SfDataGrid(
                                  source: LeasingConditionDataSource(
                                    categoryData:
                                        state.headStoreDashboard[0].leasingList,
                                  ),
                                  columnWidthMode: ColumnWidthMode.fill,
                                  horizontalScrollPhysics:
                                      NeverScrollableScrollPhysics(),
                                  verticalScrollPhysics:
                                      NeverScrollableScrollPhysics(),
                                  columns: [
                                    GridColumn(
                                      columnName: 'name',
                                      minimumWidth: 52,
                                      label: Align(
                                        alignment: Alignment.center,
                                        child: Text(''),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'total',
                                      minimumWidth: 52,
                                      label: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Total SPK',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'proses',
                                      minimumWidth: 48,
                                      label: Align(
                                        alignment: Alignment.center,
                                        child: Text('Proses'),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'terbuka',
                                      minimumWidth: 56,
                                      label: Align(
                                        alignment: Alignment.center,
                                        child: Text('Terbuka'),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'unit',
                                      minimumWidth: 36,
                                      label: Align(
                                        alignment: Alignment.center,
                                        child: Text('App'),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: '%',
                                      minimumWidth: 64,
                                      label: Align(
                                        alignment: Alignment.center,
                                        child: Text('% App'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ~:Prospek & STU per Day:~
                      ProspekStuCharts(data: headDashboardData.dailyList),

                      // ~:DB & STU:~
                      DbStuCharts(data: headDashboardData.prospekTypeList),
                    ],
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Something went wrong!',
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}
