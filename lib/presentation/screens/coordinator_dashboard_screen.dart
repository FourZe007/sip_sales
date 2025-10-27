import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sip_sales_clean/presentation/blocs/shop_coordinator/shop_coordinator_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/shop_coordinator/shop_coordinator_event.dart';
import 'package:sip_sales_clean/presentation/blocs/shop_coordinator/shop_coordinator_state.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/datagrids/leasing_condition.dart';
import 'package:sip_sales_clean/presentation/widgets/datagrids/sales_category.dart';
import 'package:sip_sales_clean/presentation/widgets/datagrids/salesman_prospek.dart';
import 'package:sip_sales_clean/presentation/widgets/datagrids/salesman_stu.dart';
import 'package:sip_sales_clean/presentation/widgets/graphs/db_stu.dart';
import 'package:sip_sales_clean/presentation/widgets/graphs/prospek_stu.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/templates/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CoordinatorDashboard extends StatefulWidget {
  const CoordinatorDashboard({required this.employeeId, super.key});

  final String employeeId;

  @override
  State<CoordinatorDashboard> createState() => _CoordinatorDashboardState();
}

class _CoordinatorDashboardState extends State<CoordinatorDashboard> {
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
    return BlocBuilder<ShopCoordinatorBloc, ShopCoordinatorState>(
      builder: (context, state) {
        if (state is CoordinatorDashboardLoading) {
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
        } else if (state is CoordinatorDashboardError) {
          return Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ~:Error Text:~
              Text(
                'Error: ${state.message}',
                textAlign: TextAlign.center,
                style: TextThemes.normal.copyWith(
                  fontSize: 16,
                  backgroundColor: Colors.transparent,
                ),
              ),

              // ~:Reload Button:~
              ElevatedButton(
                onPressed: () async => context.read<ShopCoordinatorBloc>().add(
                  LoadCoordinatorDashboard(
                    widget.employeeId,
                    DateTime.now().toIso8601String().split('T')[0],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 40),
                ),
                child: Text(
                  'Refresh',
                  style: TextThemes.normalTextButton.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          );
        } else if (state is CoordinatorDashboardLoaded) {
          log('Coordinator length: ${state.coordData.length}');

          return ListView.builder(
            itemCount: state.coordData.length,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(4, 0, 4, 8),
            itemBuilder: (context, index) {
              final coordData = state.coordData[index];
              double salesProspectHeight =
                  52 + coordData.prospekList.length * 50;
              double salesFUOverviewHeight =
                  52 + coordData.salesFUOverviewList.length * 50;
              double salesStuHeight = 52 + coordData.stuList.length * 50;
              double categoryHeight = 52 + coordData.categoryList.length * 50;
              double leasingHeight = 52 + coordData.leasingList.length * 50;

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
                                value: coordData.prospek,
                                labelSize: 12,
                              ),
                            ),

                            // ~:SPK:~
                            Expanded(
                              child: Widgets.buildStatBox(
                                context: context,
                                label: 'SPK',
                                value: coordData.spk,
                                labelSize: 12,
                              ),
                            ),

                            // ~:SPK Terbuka:~
                            Expanded(
                              child: Widgets.buildStatBox(
                                context: context,
                                label: 'Terbuka',
                                value: coordData.spkTerbuka,
                                labelSize: 12,
                              ),
                            ),

                            // ~:STU:~
                            Expanded(
                              child: Widgets.buildStatBox(
                                context: context,
                                label: 'STU',
                                value: coordData.stu,
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
                              style: TextThemes.normal.copyWith(
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
                                value: coordData.prospekH,
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
                                value: coordData.spkh,
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
                                value: coordData.spkTerbukaH,
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
                                value: coordData.stuh,
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

                  // ~:Salesman Prospect:~
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        spacing: 8,
                        children: [
                          // ~:Title:~
                          Text(
                            'Prospek Salesman',
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
                                    state.coordData[0].prospekList,
                                // date: DateFormat(
                                //   'yyyy-MM-dd',
                                // ).format(DateTime.now()),
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

                  // ~:Salesman STU:~
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        spacing: 8,
                        children: [
                          // ~:Title:~
                          Text(
                            'STU Salesman',
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
                                salesmanSTUData: state.coordData[0].stuList,
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
                                categoryData: state.coordData[0].categoryList,
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
                                categoryData: state.coordData[0].leasingList,
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
                  ProspekStuCharts(data: coordData.dailyList),

                  // ~:DB & STU:~
                  DbStuCharts(data: coordData.prospekTypeList),
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
