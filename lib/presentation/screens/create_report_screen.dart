import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/core/constant/enum.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/leasing_data_table.dart';
import 'package:sip_sales_clean/data/models/payment_data_table.dart';
import 'package:sip_sales_clean/data/models/sales.dart';
import 'package:sip_sales_clean/data/models/salesman_data_table.dart';
import 'package:sip_sales_clean/data/models/stu_data_table.dart';
import 'package:sip_sales_clean/presentation/blocs/leasing_table/leasing_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/leasing_table/leasing_event.dart';
import 'package:sip_sales_clean/presentation/blocs/leasing_table/leasing_state.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/blocs/payment_table/payment_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/payment_table/payment_event.dart';
import 'package:sip_sales_clean/presentation/blocs/payment_table/payment_state.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman_table/salesman_table_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman_table/salesman_table_event.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman_table/salesman_table_state.dart';
import 'package:sip_sales_clean/presentation/blocs/stu_table/stu_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/stu_table/stu_event.dart';
import 'package:sip_sales_clean/presentation/blocs/stu_table/stu_state.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/datagrids/report.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/insertation/leasing_report.dart';
import 'package:sip_sales_clean/presentation/widgets/insertation/payment_report.dart';
import 'package:sip_sales_clean/presentation/widgets/insertation/salesman_report.dart';
import 'package:sip_sales_clean/presentation/widgets/insertation/stu_report.dart';
import 'package:sip_sales_clean/presentation/widgets/textfields/custom_textformfield.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController personController = TextEditingController();

  late LeasingInsertDataSource _leasingDataSource;
  late SalesmanInsertDataSource _salesmanDataSource;
  double tableHeight = 260;

  List<StuData> stuData = [];
  List<PaymentData> paymentData = [];
  List<LeasingData> leasingData = [];
  List<SalesmanData> salesmanData = [];
  List<SalesModel> salesData = [];

  void editStuValue(
    StuBloc stuBloc,
    int rowIndex,
    String columnName,
    int newValue,
  ) {
    if (columnName == 'Result') {
      stuBloc.add(ModifyStuData(rowIndex: rowIndex, newResultValue: newValue));
    } else if (columnName == 'Target') {
      stuBloc.add(ModifyStuData(rowIndex: rowIndex, newTargetValue: newValue));
    } else if (columnName == 'LM') {
      stuBloc.add(ModifyStuData(rowIndex: rowIndex, newLmValue: newValue));
    }
  }

  void editPaymentValue(
    PaymentBloc paymentBloc,
    int rowIndex,
    String columnName,
    int newValue,
  ) {
    if (columnName == 'Result') {
      paymentBloc.add(
        PaymentDataModified(rowIndex: rowIndex, newResultValue: newValue),
      );
    } else if (columnName == 'LM') {
      paymentBloc.add(
        PaymentDataModified(rowIndex: rowIndex, newTargetValue: newValue),
      );
    }
  }

  void editLeasingValue(
    LeasingBloc leasingBloc,
    int rowIndex,
    String columnName,
    int newValue,
  ) {
    log('Column name: $columnName');
    if (columnName == 'Accepted') {
      // 'accept'
      leasingBloc.add(
        LeasingDataModified(
          rowIndex: rowIndex,
          columnName: columnName,
          newValue: newValue,
        ),
      );
    } else if (columnName == 'Rejected') {
      // 'reject'
      leasingBloc.add(
        LeasingDataModified(
          rowIndex: rowIndex,
          columnName: columnName,
          newValue: newValue,
        ),
      );
    } else if (columnName == 'SPK') {
      // 'spk'
      leasingBloc.add(
        LeasingDataModified(
          rowIndex: rowIndex,
          columnName: columnName,
          newValue: newValue,
        ),
      );
    } else if (columnName == 'Opened') {
      // 'opened'
      leasingBloc.add(
        LeasingDataModified(
          rowIndex: rowIndex,
          columnName: columnName,
          newValue: newValue,
        ),
      );
    }
  }

  void editSalesmanValue(
    SalesmanTableBloc salesmanBloc,
    int rowIndex,
    String columnName,
    int newValue,
  ) {
    log('Editing salesman at row $rowIndex, column $columnName: $newValue');
    // Add validation for row index
    if (rowIndex < 0) {
      log('Invalid row index: $rowIndex');
      return;
    }
    log('Row index: $rowIndex');
    log('New value: $newValue');
    if (columnName == 'SPK') {
      // 'SPK'
      salesmanBloc.add(
        ModifySalesman(
          rowIndex: rowIndex,
          columnName: columnName,
          newValue: newValue,
        ),
      );
    } else if (columnName == 'STU') {
      // 'STU'
      salesmanBloc.add(
        ModifySalesman(
          rowIndex: rowIndex,
          columnName: columnName,
          newValue: newValue,
        ),
      );
    } else if (columnName == 'STU LM') {
      // 'STU LM'
      salesmanBloc.add(
        ModifySalesman(
          rowIndex: rowIndex,
          columnName: columnName,
          newValue: newValue,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize data source with initial empty data
    _leasingDataSource = LeasingInsertDataSource(
      [],
      onCellValueEdited: (rowIndex, columnName, newValue) => editLeasingValue(
        context.read<LeasingBloc>(),
        rowIndex,
        columnName,
        newValue,
      ),
    );

    _salesmanDataSource = SalesmanInsertDataSource(
      [],
      onCellValueEdited: (rowIndex, columnName, newValue) => editSalesmanValue(
        context.read<SalesmanTableBloc>(),
        rowIndex,
        columnName,
        newValue,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _leasingDataSource.dispose();
    _salesmanDataSource.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        toolbarHeight: 60,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Text(
          'Daily Report',
          style: TextThemes.normal.copyWith(
            fontSize: 16,
          ),
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            spacing: 12,
            children: [
              // ~:Page Content:~
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    spacing: 12,
                    children: [
                      // ~:Header:~
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ~:Title:~
                            Text(
                              'Informasi Laporan',
                              style: TextThemes.subtitle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // ~:Description:~
                            Text(
                              'Masukkan data untuk membuat laporan harian.',
                              style: TextThemes.normal,
                            ),
                          ],
                        ),
                      ),

                      // ~:Body:~
                      Column(
                        spacing: 8,
                        children: [
                          // ~:Textfields:~
                          Column(
                            spacing: 4,
                            children: [
                              // ~:Dealer Textfield:~
                              BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, state) {
                                  if (state is LoginSuccess) {
                                    // ~:Set the dealer controller text:~
                                    if (locationController.text.isEmpty) {
                                      locationController.text =
                                          Formatter.toTitleCase(
                                            state.user.employeeName,
                                          );
                                    }
                                  }

                                  return CustomTextFormField(
                                    'your location',
                                    'Location',
                                    const Icon(Icons.garage_rounded),
                                    locationController,
                                    inputFormatters: [
                                      Formatter.normalFormatter,
                                    ],
                                    borderRadius: 20,
                                    isEnabled: false,
                                  );
                                },
                              ),

                              // ~:Area Textfield:~
                              BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, state) {
                                  if (state is LoginSuccess) {
                                    // ~:Set the area controller text:~
                                    if (areaController.text.isEmpty) {
                                      areaController.text =
                                          '${state.user.branch} ${Formatter.toBranchShopName(state.user.bsName)}';
                                    }
                                  }

                                  return CustomTextFormField(
                                    'your area',
                                    'Area',
                                    const Icon(Icons.location_pin),
                                    areaController,
                                    isLabelFloat: true,
                                    inputFormatters: [
                                      Formatter.normalFormatter,
                                    ],
                                    borderRadius: 20,
                                    isEnabled: false,
                                  );
                                },
                              ),

                              // ~:PIC Textfield:~
                              CustomTextFormField(
                                'your PIC name',
                                'PIC',
                                const Icon(Icons.person),
                                personController,
                                isLabelFloat: true,
                                inputFormatters: [
                                  Formatter.normalFormatter,
                                ],
                                borderRadius: 20,
                              ),
                            ],
                          ),

                          // ~:Input Tables:~
                          Column(
                            spacing: 12,
                            children: [
                              // ~:STU Input Table:~
                              BlocBuilder<StuBloc, StuState>(
                                builder: (context, state) {
                                  stuData = state.data;
                                  if (state is StuDataModified) {
                                    stuData = state.newData;
                                  }

                                  return ReportDataGrid(
                                    dataSource: StuInsertDataSource(
                                      stuData,
                                      onCellValueEdited:
                                          (
                                            rowIndex,
                                            columnName,
                                            newValue,
                                          ) => editStuValue(
                                            context.read<StuBloc>(),
                                            rowIndex,
                                            columnName,
                                            newValue,
                                          ),
                                    ),
                                    tableHeight: 310,
                                    loadedData: StuType.values
                                        .map((e) => e.name.toString())
                                        .toList(),
                                    allowEditing: true,
                                    horizontalScrollPhysics:
                                        const BouncingScrollPhysics(),
                                    textStyle: TextThemes.normal,
                                  );
                                },
                              ),

                              // ~:Payment Input Table:~
                              BlocBuilder<PaymentBloc, PaymentState>(
                                builder: (context, state) {
                                  paymentData = state.data;
                                  if (state is PaymentModified) {
                                    paymentData = state.newData;
                                    // log('New Payment length: ${paymentData.length}');
                                  }

                                  return ReportDataGrid(
                                    dataSource: PaymentInsertDataSource(
                                      paymentData,
                                      onCellValueEdited:
                                          (
                                            rowIndex,
                                            columnName,
                                            newValue,
                                          ) => editPaymentValue(
                                            context.read<PaymentBloc>(),
                                            rowIndex,
                                            columnName,
                                            newValue,
                                          ),
                                    ),
                                    loadedData: PaymentType.values
                                        .map((e) => e.name.toString())
                                        .toList(),
                                    tableHeight: 215,
                                    allowEditing: true,
                                    horizontalScrollPhysics:
                                        const BouncingScrollPhysics(),
                                    textStyle: TextThemes.normal,
                                  );
                                },
                              ),

                              // ~:Leasing Input Table:~
                              BlocBuilder<LeasingBloc, LeasingState>(
                                builder: (context, state) {
                                  tableHeight = 410;
                                  leasingData = state.data;

                                  if (state is AddLeasingData) {
                                    leasingData = state.newData;
                                    // Update the existing data source with new data
                                    _leasingDataSource.updateData(
                                      leasingData,
                                    );
                                  } else if (state is LeasingInitial) {
                                    // Handle initial state
                                    _leasingDataSource.updateData(
                                      leasingData,
                                    );
                                  }

                                  log(
                                    'Leasing length: ${state.data.length}',
                                  );
                                  return ReportDataGrid(
                                    dataSource: _leasingDataSource,
                                    loadedData: LeasingType.values
                                        .map((e) => e.name.toString())
                                        .toList(),
                                    tableHeight: tableHeight,
                                    allowEditing: true,
                                    horizontalScrollPhysics:
                                        const BouncingScrollPhysics(),
                                    textStyle: TextThemes.normal,
                                  );
                                },
                              ),

                              // ~:Salesman Input Table:~
                              BlocBuilder<
                                SalesmanTableBloc,
                                SalesmanTableState
                              >(
                                builder: (context, state) {
                                  salesData = state.fetchSalesList
                                      .where((e) => e.isActive == 1)
                                      .toList();
                                  if (state is SalesmanLoading) {
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
                                  } else if (state is SalesmanFetched) {
                                    salesmanData = state.salesDataList;
                                    _salesmanDataSource.updateData(
                                      salesmanData,
                                    );
                                  } else if (state is SalesmanModified) {
                                    salesmanData = state.newData;
                                    _salesmanDataSource.updateData(
                                      salesmanData,
                                    );
                                  }
                                  log(
                                    'Salesman length: ${salesmanData.length}',
                                  );

                                  tableHeight = 120;
                                  if (salesmanData.length < 6) {
                                    tableHeight += double.parse(
                                      (50 * salesmanData.length).toString(),
                                    );
                                  } else {
                                    tableHeight = 410;
                                  }

                                  // ~:Set a dynamic table height:~
                                  if (salesmanData.isEmpty) {
                                    return const SizedBox();
                                  }

                                  return ReportDataGrid(
                                    dataSource: _salesmanDataSource,
                                    loadedData: SalesmanType.values
                                        .map((e) => e.name.toString())
                                        .toList(),
                                    tableHeight: tableHeight,
                                    rowHeaderWidth: 75,
                                    allowEditing: true,
                                    horizontalScrollPhysics:
                                        const BouncingScrollPhysics(),
                                    verticalScrollPhysics:
                                        salesmanData.length < 6
                                        ? const NeverScrollableScrollPhysics()
                                        : const AlwaysScrollableScrollPhysics(),
                                    columnWidthMode:
                                        ColumnWidthMode.fitByCellValue,
                                    textStyle: TextThemes.normal,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ~:Page Content - Footer:~
              // Create Report Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 24,
                  alignment: Alignment.center,
                  child: Text(
                    'Buat',
                    style: TextThemes.subtitle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
