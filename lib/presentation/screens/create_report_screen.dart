import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sip_sales_clean/core/constant/enum.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store.event.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_state.dart';
import 'package:sip_sales_clean/presentation/blocs/leasing_table/leasing_table_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/leasing_table/leasing_table_event.dart';
import 'package:sip_sales_clean/presentation/blocs/leasing_table/leasing_table_state.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/blocs/payment_table/payment_table_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/payment_table/payment_table_event.dart';
import 'package:sip_sales_clean/presentation/blocs/payment_table/payment_table_state.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman_table/salesman_table_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman_table/salesman_table_event.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman_table/salesman_table_state.dart';
import 'package:sip_sales_clean/presentation/blocs/stu_table/stu_table_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/stu_table/stu_table_event.dart';
import 'package:sip_sales_clean/presentation/blocs/stu_table/stu_table_state.dart';
import 'package:sip_sales_clean/presentation/cubit/date_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/head_acts_master.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/datagrids/report.dart';
import 'package:sip_sales_clean/presentation/widgets/image/dotted_rounded_image_picker.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_ios_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/insertation/leasing_report.dart';
import 'package:sip_sales_clean/presentation/widgets/insertation/payment_report.dart';
import 'package:sip_sales_clean/presentation/widgets/insertation/salesman_report.dart';
import 'package:sip_sales_clean/presentation/widgets/insertation/stu_report.dart';
import 'package:sip_sales_clean/presentation/widgets/textfields/custom_textformfield.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  // final TextEditingController personController = TextEditingController();

  late LeasingInsertDataSource _leasingDataSource;
  late SalesmanInsertDataSource _salesmanDataSource;
  double stuTableHeight = 0;
  double paymentTableHeight = 0;
  double leasingTableHeight = 0;
  double salesmanTableHeight = 0;

  List<HeadStuCategoriesMasterModel> stuData = [];
  List<HeadPaymentMasterModel> paymentData = [];
  List<HeadLeasingMasterModel> leasingData = [];
  List<HeadEmployeeMasterModel> salesmanData = [];
  List<HeadReportMasterModel> salesData = [];

  void editStuValue(
    StuTableBloc stuBloc,
    int rowIndex,
    String columnName,
    int newValue,
  ) {
    if (columnName == 'Tm') {
      stuBloc.add(ModifyStuData(rowIndex: rowIndex, newTmValue: newValue));
    } else if (columnName == 'Target') {
      stuBloc.add(ModifyStuData(rowIndex: rowIndex, newTargetValue: newValue));
    } else if (columnName == 'LM') {
      stuBloc.add(ModifyStuData(rowIndex: rowIndex, newLmValue: newValue));
    }
  }

  void editPaymentValue(
    PaymentTableBloc paymentBloc,
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
    LeasingTableBloc leasingBloc,
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

    log('Initializing CreateReportScreen');
    final master = context.read<HeadActsMasterCubit>().state;
    if (master is HeadActsMasterLoaded && master.reportMaster.isNotEmpty) {
      stuData = master.reportMaster[0].stuCategories;
      paymentData = master.reportMaster[0].payment;
      leasingData = master.reportMaster[0].spkLeasing;
      salesmanData = master.reportMaster[0].employee;

      context.read<StuTableBloc>().add(ResetStuData(stuData));
      context.read<PaymentTableBloc>().add(ResetPaymentData(paymentData));
      context.read<LeasingTableBloc>().add(ResetLeasingData(leasingData));
      context.read<SalesmanTableBloc>().add(ResetSalesman(salesmanData));
    }

    _leasingDataSource = LeasingInsertDataSource(
      leasingData,
      onCellValueEdited: (rowIndex, columnName, newValue) => editLeasingValue(
        context.read<LeasingTableBloc>(),
        rowIndex,
        columnName,
        newValue,
      ),
    );

    _salesmanDataSource = SalesmanInsertDataSource(
      salesmanData,
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
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            Platform.isIOS ? 8 : MediaQuery.of(context).padding.bottom + 4,
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
                                            state.user.bsName,
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
                                          Formatter.toTitleCase(
                                            state.user.locationName,
                                          );
                                      // '${state.user.branch} ${Formatter.toBranchShopName(state.user.bsName)}';
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
                              // CustomTextFormField(
                              //   'your PIC name',
                              //   'PIC',
                              //   const Icon(Icons.person),
                              //   personController,
                              //   isLabelFloat: true,
                              //   inputFormatters: [
                              //     Formatter.normalFormatter,
                              //   ],
                              //   borderRadius: 20,
                              // ),
                            ],
                          ),

                          // ~:Input Tables:~
                          Column(
                            spacing: 12,
                            children: [
                              // ~:STU Input Table:~
                              BlocBuilder<StuTableBloc, StuTableState>(
                                builder: (context, state) {
                                  stuData = state.data;
                                  log('Stu length: ${stuData.length}');
                                  log('Stu height before: $stuTableHeight');
                                  stuTableHeight =
                                      (115 +
                                      double.parse(
                                        (50 * stuData.length).toString(),
                                      ));
                                  log('Stu height after: $stuTableHeight');
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
                                            context.read<StuTableBloc>(),
                                            rowIndex,
                                            columnName,
                                            newValue,
                                          ),
                                    ),
                                    tableHeight: stuTableHeight,
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
                              BlocBuilder<PaymentTableBloc, PaymentTableState>(
                                builder: (context, state) {
                                  paymentData = state.data;
                                  paymentTableHeight =
                                      (115 +
                                      double.parse(
                                        (50 * paymentData.length).toString(),
                                      ));
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
                                            context.read<PaymentTableBloc>(),
                                            rowIndex,
                                            columnName,
                                            newValue,
                                          ),
                                    ),
                                    loadedData: PaymentType.values
                                        .map((e) => e.name.toString())
                                        .toList(),
                                    rowHeaderWidth: 64,
                                    tableHeight: paymentTableHeight,
                                    allowEditing: true,
                                    horizontalScrollPhysics:
                                        const BouncingScrollPhysics(),
                                    textStyle: TextThemes.normal,
                                  );
                                },
                              ),

                              // ~:Leasing Input Table:~
                              BlocBuilder<LeasingTableBloc, LeasingTableState>(
                                buildWhen: (previous, current) =>
                                    current is AddLeasingData ||
                                    current is LeasingInitial,
                                builder: (_, state) {
                                  leasingData = state.data;
                                  leasingTableHeight =
                                      (132) + (leasingData.length * 48);

                                  if (state is AddLeasingData) {
                                    leasingData = state.newData;
                                    _leasingDataSource.updateData(
                                      leasingData,
                                    );
                                  } else if (state is LeasingInitial) {
                                    _leasingDataSource.updateData(
                                      leasingData,
                                    );
                                  }

                                  return ReportDataGrid(
                                    dataSource: _leasingDataSource,
                                    loadedData: LeasingType.values
                                        .map((e) => e.name.toString())
                                        .toList(),
                                    tableHeight: leasingTableHeight,
                                    rowHeaderWidth: 68,
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
                                  if (state is SalesmanModified) {
                                    salesmanData = state.newData;
                                    _salesmanDataSource.updateData(
                                      salesmanData,
                                    );
                                  } else if (state is SalesmanInitial) {
                                    salesmanData = state.salesmanList;
                                    _salesmanDataSource.updateData(
                                      salesmanData,
                                    );
                                  }

                                  salesmanTableHeight = 108 + (56 * 6);

                                  if (salesmanData.isEmpty) {
                                    return const SizedBox();
                                  }

                                  return ReportDataGrid(
                                    dataSource: _salesmanDataSource,
                                    loadedData: SalesmanType.values
                                        .map((e) => e.name.toString())
                                        .toList(),
                                    tableHeight: salesmanTableHeight,
                                    rowHeaderWidth: 72,
                                    rowHeight: 52,
                                    allowEditing: true,
                                    horizontalScrollPhysics:
                                        const BouncingScrollPhysics(),
                                    verticalScrollPhysics:
                                        salesmanData.length <= 6
                                        ? const NeverScrollableScrollPhysics()
                                        : const AlwaysScrollableScrollPhysics(),
                                    textStyle: TextThemes.normal,
                                  );
                                },
                              ),
                            ],
                          ),

                          // ~:Photo Section:~
                          DottedRoundedImagePicker(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ~:Page Content - Footer:~
              // Create Report Button
              ElevatedButton(
                onPressed: () async => await Functions.manageNewHeadStoreAct(
                  context,
                  '03',
                ),
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
                  child: BlocConsumer<HeadStoreBloc, HeadStoreState>(
                    buildWhen: (previous, current) =>
                        (current is HeadStoreLoading &&
                            current.isInsert &&
                            !current.isActs &&
                            !current.isDashboard) ||
                        current is HeadStoreInsertSucceed ||
                        current is HeadStoreInsertFailed,
                    listener: (context, state) {
                      if (state is HeadStoreInsertFailed) {
                        Functions.customFlutterToast(state.message);
                      } else if (state is HeadStoreInsertSucceed) {
                        Functions.customFlutterToast(
                          'Aktivitas berhasil dibuat',
                        );

                        context.read<DateCubit>().resetDate();

                        context.read<HeadStoreBloc>().add(
                          LoadHeadActs(
                            employeeID:
                                (context.read<LoginBloc>().state
                                        as LoginSuccess)
                                    .user
                                    .employeeID,
                            date: DateFormat(
                              'yyyy-MM-dd',
                            ).format(DateTime.now()),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    builder: (context, state) {
                      if (state is HeadStoreLoading &&
                          state.isInsert &&
                          !state.isActs &&
                          !state.isDashboard &&
                          !state.isActsDetail &&
                          !state.isDelete) {
                        return const AndroidIosLoading(
                          indicatorColor: Colors.black,
                          strokeWidth: 3,
                          customizedHeight: 24,
                          customizedWidth: 24,
                          iosRadius: 12,
                        );
                      } else {
                        return Text(
                          'Buat',
                          style: TextThemes.subtitle,
                          textAlign: TextAlign.center,
                        );
                      }
                    },
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
