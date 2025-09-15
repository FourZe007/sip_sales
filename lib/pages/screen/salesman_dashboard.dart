import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state/salesdashboard/sales_dashboard_bloc.dart';
import 'package:sip_sales/global/state/salesdashboard/sales_dashboard_state.dart';
import 'package:sip_sales/widget/custom.dart';
import 'package:sip_sales/widget/datagrid/leasing_condition.dart';
import 'package:sip_sales/widget/datagrid/sales_category.dart';
import 'package:sip_sales/widget/graph/db_stu.dart';
import 'package:sip_sales/widget/graph/prospek_stu.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SalesmanDashboard extends StatefulWidget {
  const SalesmanDashboard({super.key});

  @override
  State<SalesmanDashboard> createState() => _SalesmanDashboardState();
}

class _SalesmanDashboardState extends State<SalesmanDashboard> {
  /// Builds the UI for the sales dashboard screen.
  ///
  /// This screen displays the sales data in various formats, including
  /// a table, a chart, and a graph. It also displays the total number of
  /// sales, the average sale value, and the number of customers.
  ///
  /// The screen is divided into sections, each of which displays a
  /// different type of data. The sections are:
  ///
  /// *   A table that displays the sales data.
  /// *   A chart that displays the sales data.
  /// *   A graph that displays the sales data.
  /// *   A section that displays the total number of sales, the average sale
  ///     value, and the number of customers.
  ///
  /// The screen also includes a button that, when clicked, displays a
  /// dialog box with additional information about the sales data.

  @override
  void initState() {
    super.initState();
    // Initialize date formatting for Indonesian locale
    initializeDateFormatting('id_ID', null);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesDashboardBloc, SalesDashboardState>(
      builder: (context, state) {
        if (state is SalesDashboardLoading) {
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
        } else if (state is SalesDashboardError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              textAlign: TextAlign.center,
            ),
          );
        } else if (state is SalesDashboardLoaded) {
          log('Sales length: ${state.salesData.length}');
          // for (var element in state.salesData) {
          //   log('Prospek: ${element.prospek}');
          //   log('SPK: ${element.spk}');
          //   log('SPK Terbuka: ${element.spkTerbuka}');
          //   log('STU: ${element.stu}');
          // }
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: state.salesData.length,
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 8.0),
              itemBuilder: (context, index) {
                final salesData = state.salesData[index];
                double categoryHeight = 52 + salesData.categoryList.length * 50;
                double leasingHeight = 52 + salesData.leasingList.length * 50;

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
                                style: GlobalFont.mediumbigfontR.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Builder(
                                builder: (context) {
                                  DateTime now = DateTime.now();
                                  String formattedDate;

                                  if (now.day == 1) {
                                    formattedDate =
                                        DateFormat('dd MMMM yyyy', 'id_ID')
                                            .format(now);
                                  } else {
                                    formattedDate =
                                        '01 - ${DateFormat('dd MMMM yyyy', 'id_ID').format(now)}';
                                  }

                                  return Text(
                                    formattedDate,
                                    style:
                                        GlobalFont.mediumbigfontRBold.copyWith(
                                      fontSize: 16,
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
                                child: CustomWidget.buildStatBox(
                                  context: context,
                                  label: 'Prospek',
                                  value: salesData.prospek,
                                  labelSize: 12,
                                ),
                              ),

                              // ~:SPK:~
                              Expanded(
                                child: CustomWidget.buildStatBox(
                                  context: context,
                                  label: 'SPK',
                                  value: salesData.spk,
                                  labelSize: 12,
                                ),
                              ),

                              // ~:SPK Terbuka:~
                              Expanded(
                                child: CustomWidget.buildStatBox(
                                  context: context,
                                  label: 'Terbuka',
                                  value: salesData.spkTerbuka,
                                  labelSize: 12,
                                ),
                              ),

                              // ~:STU:~
                              Expanded(
                                child: CustomWidget.buildStatBox(
                                  context: context,
                                  label: 'STU',
                                  value: salesData.stu,
                                  labelSize: 12,
                                ),
                              ),

                              // ~:Delivery:~
                              // Expanded(
                              //   child: CustomWidget.buildStatBox(
                              //     context: context,
                              //     label: 'Deliv',
                              //     value: salesData.delivery,
                              //     labelSize: 12,
                              //   ),
                              // ),
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
                                style: GlobalFont.mediumbigfontRBold.copyWith(
                                  fontSize: 16,
                                ),
                              ),

                              // ~:Date:~
                              Text(
                                DateFormat('dd MMMM yyyy', 'id_ID')
                                    .format(DateTime.now()),
                                style: GlobalFont.mediumbigfontRBold.copyWith(
                                  fontSize: 16,
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
                                child: CustomWidget.buildStatBox(
                                  context: context,
                                  label: 'Prospek',
                                  value: salesData.prospekH,
                                  boxWidth: 80,
                                  boxHeight: 75,
                                  labelSize: 12,
                                  boxColor: Colors.green[200]!,
                                ),
                              ),

                              // ~:SPK:~
                              Expanded(
                                child: CustomWidget.buildStatBox(
                                  context: context,
                                  label: 'SPK',
                                  value: salesData.spkh,
                                  boxWidth: 80,
                                  boxHeight: 75,
                                  labelSize: 12,
                                  boxColor: Colors.green[200]!,
                                ),
                              ),

                              // ~:SPK Terbuka:~
                              Expanded(
                                child: CustomWidget.buildStatBox(
                                  context: context,
                                  label: 'Terbuka',
                                  value: salesData.spkTerbukaH,
                                  boxWidth: 80,
                                  boxHeight: 75,
                                  labelSize: 12,
                                  boxColor: Colors.green[200]!,
                                ),
                              ),

                              // ~:STU:~
                              Expanded(
                                child: CustomWidget.buildStatBox(
                                  context: context,
                                  label: 'STU',
                                  value: salesData.stuh,
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
                                  categoryData: state.salesData[0].categoryList,
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
                                  categoryData: state.salesData[0].leasingList,
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
                    ProspekStuCharts(data: salesData.dailyList),

                    // ~:DB & STU:~
                    DbStuCharts(data: salesData.prospekTypeList),
                  ],
                );
              },
            ),
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
