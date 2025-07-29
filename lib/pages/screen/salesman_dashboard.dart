import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state/salesdashboard/sales_dashboard_bloc.dart';
import 'package:sip_sales/global/state/salesdashboard/sales_dashboard_state.dart';
import 'package:sip_sales/widget/datagrid/leasing_condition.dart';
import 'package:sip_sales/widget/datagrid/sales_category.dart';
import 'package:sip_sales/widget/graph/db_stu.dart';
import 'package:sip_sales/widget/graph/prospek_stu.dart';
import 'package:sip_sales/widget/indicator/circleloading.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SalesmanDashboard extends StatelessWidget {
  const SalesmanDashboard({super.key});

  @override

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
          return ListView.builder(
            itemCount: state.salesData.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final salesData = state.salesData[index];

              return Column(
                spacing: 8,
                children: [
                  // ~:Akumulasi:~
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ~:Title:~
                        Text('Akumulasi'),

                        // ~:Data:~
                        Row(
                          spacing: 4,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // ~:Prospek:~
                            Container(
                              width: 64,
                              height: 75,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Text(
                                      'P',
                                      style: GlobalFont.bigfontR,
                                    ),
                                  ),
                                  Text(
                                    salesData.prospek.toString(),
                                    style: GlobalFont.bigfontRBold.copyWith(
                                      fontSize: 32,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ~:SPK:~
                            Container(
                              width: 64,
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Text(
                                      'SPK',
                                      style: GlobalFont.bigfontR,
                                    ),
                                  ),
                                  Text(
                                    salesData.spk.toString(),
                                    style: GlobalFont.bigfontRBold.copyWith(
                                      fontSize: 32,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ~:SPK Terbuka:~
                            Container(
                              width: 64,
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Text(
                                      'Tbk',
                                      style: GlobalFont.bigfontR,
                                    ),
                                  ),
                                  Text(
                                    salesData.spkTerbuka.toString(),
                                    style: GlobalFont.bigfontRBold.copyWith(
                                      fontSize: 32,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ~:STU:~
                            Container(
                              width: 64,
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Text(
                                      'STU',
                                      style: GlobalFont.bigfontR,
                                    ),
                                  ),
                                  Text(
                                    salesData.stu.toString(),
                                    style: GlobalFont.bigfontRBold.copyWith(
                                      fontSize: 32,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ~:Delivery:~
                            Container(
                              width: 64,
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Text(
                                      'Deliv',
                                      style: GlobalFont.bigfontR,
                                    ),
                                  ),
                                  Text(
                                    salesData.delivery.toString(),
                                    style: GlobalFont.bigfontRBold.copyWith(
                                      fontSize: 32,
                                    ),
                                  ),
                                ],
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
                    height: 120,
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ~:Title:~
                        Text('Harian'),

                        // ~:Data:~
                        Row(
                          spacing: 4,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // ~:Prospek:~
                            Container(
                              width: 80,
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.green[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Text(
                                      'P',
                                      style: GlobalFont.bigfontR,
                                    ),
                                  ),
                                  Text(
                                    salesData.prospek.toString(),
                                    style: GlobalFont.bigfontRBold.copyWith(
                                      fontSize: 32,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ~:SPK:~
                            Container(
                              width: 80,
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.green[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Text(
                                      'SPK',
                                      style: GlobalFont.bigfontR,
                                    ),
                                  ),
                                  Text(
                                    salesData.spk.toString(),
                                    style: GlobalFont.bigfontRBold.copyWith(
                                      fontSize: 32,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ~:SPK Terbuka:~
                            Container(
                              width: 80,
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.green[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Text(
                                      'Tbk',
                                      style: GlobalFont.bigfontR,
                                    ),
                                  ),
                                  Text(
                                    salesData.spkTerbuka.toString(),
                                    style: GlobalFont.bigfontRBold.copyWith(
                                      fontSize: 32,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ~:STU:~
                            Container(
                              width: 80,
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.green[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Text(
                                      'STU',
                                      style: GlobalFont.bigfontR,
                                    ),
                                  ),
                                  Text(
                                    salesData.stu.toString(),
                                    style: GlobalFont.bigfontRBold.copyWith(
                                      fontSize: 32,
                                    ),
                                  ),
                                ],
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
                            height: 300, // Fixed height for the grid
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: SfDataGrid(
                              source: SalesCategoryDataSource(
                                categoryData: state.salesData[0].categoryList,
                              ),
                              columnWidthMode: ColumnWidthMode.fill,
                              verticalScrollPhysics:
                                  NeverScrollableScrollPhysics(),
                              columns: [
                                GridColumn(
                                  columnName: 'method',
                                  minimumWidth: 120,
                                  label: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Cara Jual'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'pros',
                                  minimumWidth: 60,
                                  label: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('PROS'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'spk',
                                  minimumWidth: 50,
                                  label: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('SPK'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'stu',
                                  minimumWidth: 50,
                                  label: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('STU'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'lm',
                                  minimumWidth: 50,
                                  label: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('LM'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: '%',
                                  minimumWidth: 60,
                                  label: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Ratio'),
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
                            'Leasing Condition',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // ~:Table:~
                          Container(
                            height: 300, // Fixed height for the grid
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: SfDataGrid(
                              source: LeasingConditionDataSource(
                                categoryData: state.salesData[0].leasingList,
                              ),
                              columnWidthMode: ColumnWidthMode.fill,
                              verticalScrollPhysics:
                                  NeverScrollableScrollPhysics(),
                              columns: [
                                GridColumn(
                                  columnName: 'name',
                                  minimumWidth: 75,
                                  label: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Leasing'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'total',
                                  minimumWidth: 75,
                                  label: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Total SPK',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'proses',
                                  minimumWidth: 65,
                                  label: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Proses'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'terbuka',
                                  minimumWidth: 70,
                                  label: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Terbuka'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'unit',
                                  minimumWidth: 50,
                                  label: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Unit'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: '%',
                                  minimumWidth: 75,
                                  label: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Ratio'),
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
