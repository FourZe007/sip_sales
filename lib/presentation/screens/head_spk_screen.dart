import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sip_sales_clean/core/constant/enum.dart';
import 'package:sip_sales_clean/data/models/employee.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/cubit/dashboard_slidingup_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/spk_leasing_data_cubit.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/providers/filter_state_provider.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/datagrids/detail_per_category.dart';
import 'package:sip_sales_clean/presentation/widgets/datagrids/detail_per_leasing.dart';
import 'package:sip_sales_clean/presentation/widgets/datagrids/detail_reject.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/templates/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class HeadSpkScreen extends StatefulWidget {
  const HeadSpkScreen({super.key});

  @override
  State<HeadSpkScreen> createState() => _HeadSpkScreenState();
}

class _HeadSpkScreenState extends State<HeadSpkScreen> {
  void refreshSpkLeasingDashboard(
    BuildContext context,
    EmployeeModel employee,
  ) async {
    log('Refresh SPK Leasing');

    context.read<SpkLeasingDataCubit>().loadData(
      employee.employeeID,
      context.read<FilterStateProvider>().selectedDate.value.isEmpty
          ? DateFormat('yyyy-MM-dd').format(DateTime.now())
          : context.read<FilterStateProvider>().selectedDate.value,
      '${employee.branch}${employee.shop}',
      context.read<FilterStateProvider>().selectedCategory.value,
      context.read<FilterStateProvider>().selectedLeasing.value,
      '',
    );
  }

  @override
  void initState() {
    super.initState();

    initializeDateFormatting('id_ID', null);
  }

  @override
  Widget build(BuildContext context) {
    // // ~:Filter:~
    //     SizedBox(
    //       width: MediaQuery.of(context).size.width,
    //       height: 40,
    //       child: Row(
    //         spacing: 8,
    //         children: [
    //           // ~:Icon:~
    //           ElevatedButton(
    //             onPressed: null,
    //             style: ElevatedButton.styleFrom(
    //               minimumSize: const Size(32, 32),
    //               padding: EdgeInsets.all(4),
    //               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //               backgroundColor: Colors.grey[400],
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(12),
    //               ),
    //             ),
    //             child: const Icon(
    //               Icons.filter_alt_rounded,
    //               size: 30.0,
    //               color: Colors.black,
    //             ),
    //           ),
    //
    //           // ~:Body:~
    //           Expanded(
    //             child: SingleChildScrollView(
    //               scrollDirection: Axis.horizontal,
    //               physics: BouncingScrollPhysics(),
    //               child: Row(
    //                 spacing: 4,
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   ElevatedButton(
    //                     onPressed: () async {
    //                       final DateTime? picked = await showDatePicker(
    //                         context: context,
    //                         initialDate: DateTime.now(),
    //                         firstDate: DateTime(1990),
    //                         lastDate: DateTime.now(),
    //                       );
    //                       if (picked != null && context.mounted) {
    //                         setDate(picked.toString().substring(0, 10));
    //                       }
    //                     },
    //                     child: Text(
    //                       Formatter.dateFormat(date),
    //                       style: TextThemes.normal.copyWith(fontSize: 16),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
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
      padding: EdgeInsets.fromLTRB(12, 16, 12, 0),
      // ~:Filter Section:~
      // DecoratedBox(
      //   decoration: BoxDecoration(
      //     border: Border.all(color: Colors.black),
      //   ),
      //   child: Row(
      //     spacing: 4,
      //     children: [
      //       // Text('Filter'),
      //       IconButton(
      //         onPressed: () {},
      //         padding: EdgeInsets.all(0),
      //         constraints: BoxConstraints(),
      //         tooltip: 'Filter',
      //         style: IconButton.styleFrom(
      //           backgroundColor: Colors.grey,
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(12),
      //           ),
      //           iconSize: 24,
      //           minimumSize: Size(32, 32),
      //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      //         ),
      //         icon: Icon(Icons.filter_alt_rounded),
      //         color: Colors.black,
      //       ),
      //
      //       Expanded(
      //         child: BlocBuilder<SpkLeasingFilterCubit, SpkLeasingFilterState>(
      //           builder: (context, state) {
      //             if (state.categoryList.isNotEmpty &&
      //                 state.leasingList.isNotEmpty &&
      //                 state.dealerList.isNotEmpty &&
      //                 state.groupDealerList.isNotEmpty) {
      //               // return Text(
      //               //   'Category: ${state.categoryList.length}, Leasing: ${state.leasingList.length}, Dealer: ${state.dealerList.length}, Group Dealer: ${state.groupDealerList.length}',
      //               //   overflow: TextOverflow.ellipsis,
      //               // );
      //               return SingleChildScrollView(
      //                 scrollDirection: Axis.horizontal,
      //                 physics: BouncingScrollPhysics(),
      //                 padding: EdgeInsets.symmetric(vertical: 4),
      //                 child: Row(
      //                   spacing: 4,
      //                   children: [
      //                     Widgets.buildFilterChip(
      //                       context: context,
      //                       label: 'Category',
      //                       value: state.categoryList.length,
      //                       onTap: () => context
      //                           .read<DashboardSlidingUpCubit>()
      //                           .changeType(
      //                             DashboardSlidingUpType.leasing,
      //                           ),
      //                     ),
      //                   ],
      //                 ),
      //               );
      //             }
      //
      //             return SizedBox.shrink();
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      child: Column(
        spacing: 12,
        children: [
          // ~:Filter:~
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: Row(
              spacing: 8,
              children: [
                // ~:Body:~
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: SizedBox(
                      height: 32,
                      child: Row(
                        spacing: 4,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ~:Date:~
                          ElevatedButton(
                            onPressed: () async {
                              final displayDate =
                                  context
                                      .read<FilterStateProvider>()
                                      .selectedDate
                                      .value
                                      .isEmpty
                                  ? DateTime.now().toIso8601String().substring(
                                      0,
                                      10,
                                    )
                                  : context
                                        .read<FilterStateProvider>()
                                        .selectedDate
                                        .value
                                        .substring(0, 10);

                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.parse(displayDate),
                                currentDate: DateTime.parse(displayDate),
                                firstDate: DateTime(1990),
                                lastDate: DateTime.now().add(
                                  Duration(days: 365 * 10),
                                ),
                              );

                              if (picked != null && context.mounted) {
                                final savedDate =
                                    picked.toIso8601String().isEmpty
                                    ? DateTime.now().toIso8601String()
                                    : picked.toIso8601String();

                                context
                                    .read<FilterStateProvider>()
                                    .setSelectedDate(
                                      savedDate.substring(0, 10),
                                    );

                                // ~:Load Employee Data:~
                                final employee =
                                    (context.read<LoginBloc>().state
                                            as LoginSuccess)
                                        .user;

                                // ~:Load data with current active filters:~
                                context.read<SpkLeasingDataCubit>().loadData(
                                  employee.employeeID,
                                  (context
                                          .read<FilterStateProvider>()
                                          .selectedDate
                                          .value)
                                      .substring(0, 10),
                                  "${employee.branch}${employee.shop}", // employee data
                                  context
                                      .read<FilterStateProvider>()
                                      .selectedCategory
                                      .value, // category name
                                  context
                                      .read<FilterStateProvider>()
                                      .selectedLeasing
                                      .value, // leasing name
                                  '',
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: Colors.grey[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: ValueListenableBuilder<String>(
                              valueListenable: context
                                  .read<FilterStateProvider>()
                                  .selectedDate,
                              builder: (context, selectedDate, _) {
                                log('Displaying selected date: $selectedDate');
                                if (selectedDate.isEmpty) {
                                  return Text(
                                    'Tgl ${(DateFormat('dd-MM-yyyy', 'id_ID').format(DateTime.now()))}',
                                    style: TextThemes.normal.copyWith(
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                } else {
                                  return Text(
                                    'Tgl ${(DateFormat('dd-MM-yyyy', 'id_ID').format(DateTime.parse(selectedDate)))}',
                                    style: TextThemes.normal.copyWith(
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                }
                              },
                            ),
                          ),

                          // ~:Group Dealer:~
                          // ElevatedButton.icon(
                          //   onPressed: () => context
                          //       .read<DashboardSlidingUpCubit>()
                          //       .changeType(DashboardSlidingUpType.groupDealer),
                          //   style: ElevatedButton.styleFrom(
                          //     padding: EdgeInsets.symmetric(
                          //       horizontal: 8,
                          //     ),
                          //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          //     backgroundColor: Colors.grey[400],
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(16),
                          //     ),
                          //   ),
                          //   icon: Icon(
                          //     Icons.keyboard_arrow_down_rounded,
                          //     size: 20,
                          //     color: Colors.black,
                          //   ),
                          //   iconAlignment: IconAlignment.end,
                          //   label: Text(
                          //     "Semua grup dealer",
                          //     style: TextThemes.normal,
                          //   ),
                          // ),

                          // ~:Dealer:~
                          ElevatedButton.icon(
                            onPressed: () async => context
                                .read<DashboardSlidingUpCubit>()
                                .changeType(DashboardSlidingUpType.dealer),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: Colors.grey[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: Colors.black,
                            ),
                            iconAlignment: IconAlignment.end,
                            label: Text(
                              "Semua dealer",
                              style: TextThemes.normal,
                            ),
                          ),

                          // ~:Leasing:~
                          ElevatedButton.icon(
                            onPressed: () => context
                                .read<DashboardSlidingUpCubit>()
                                .changeType(DashboardSlidingUpType.leasing),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: Colors.grey[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: Colors.black,
                            ),
                            iconAlignment: IconAlignment.end,
                            label: ValueListenableBuilder<String>(
                              valueListenable: context
                                  .read<FilterStateProvider>()
                                  .selectedLeasing,
                              builder: (context, selectedLeasing, _) {
                                return Text(
                                  // This line is not reactive, it won't change if the filter value changes.
                                  // To make it reactive, you need to use a state management solution like provider or riverpod.
                                  selectedLeasing.isEmpty ||
                                          selectedLeasing == 'Semua'
                                      ? "Semua Leasing"
                                      : selectedLeasing,
                                  style: TextThemes.normal,
                                );
                              },
                            ),
                          ),

                          // ~:Category:~
                          ElevatedButton.icon(
                            onPressed: () => context
                                .read<DashboardSlidingUpCubit>()
                                .changeType(
                                  DashboardSlidingUpType.category,
                                ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: Colors.grey[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: Colors.black,
                            ),
                            iconAlignment: IconAlignment.end,
                            label: ValueListenableBuilder<String>(
                              valueListenable: context
                                  .read<FilterStateProvider>()
                                  .selectedCategory,
                              builder: (context, selectedCategory, _) {
                                return Text(
                                  selectedCategory.isEmpty ||
                                          selectedCategory == 'Semua'
                                      ? "Semua Kategori"
                                      : selectedCategory,
                                  style: TextThemes.normal,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ~:Header:~
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(24, 24),
                    padding: EdgeInsets.all(4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(
                    Icons.filter_alt_rounded,
                    size: 24.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // ~:Body:~
          Expanded(
            child: BlocBuilder<SpkLeasingDataCubit, SpkLeasingDataState>(
              builder: (context, state) {
                if (state is SpkLeasingDataLoading) {
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
                } else if (state is SpkLeasingDataFailed) {
                  return Column(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ~:Error Text:~
                      Text(
                        state.message == 'No Data'
                            ? 'Data Tidak Ditemukan'
                            : 'Error: ${state.message}',
                        textAlign: TextAlign.center,
                        style: TextThemes.normal.copyWith(
                          fontSize: 16,
                          backgroundColor: Colors.transparent,
                        ),
                      ),

                      // ~:Reload Button:~
                      ElevatedButton(
                        onPressed: () => refreshSpkLeasingDashboard(
                          context,
                          (context.read<LoginBloc>().state as LoginSuccess)
                              .user,
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
                } else if (state is SpkLeasingDataLoaded) {
                  final double detailPerLeasingHeight =
                      56 + state.result.detail1.length * 50;
                  final double detailPerCategoryHeight =
                      52 + state.result.detail2.length * 50;
                  final double detailRejectHeight =
                      52 + state.result.detail3.length * 50;

                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      spacing: 8,
                      children: [
                        Row(
                          spacing: 4,
                          children: [
                            Expanded(
                              child: Widgets.buildStatBox(
                                context: context,
                                label: 'Total SPK',
                                value: state.result.totalSPK.toString(),
                                labelSize: 12,
                                boxColor: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Widgets.buildStatBox(
                                context: context,
                                label: 'SPK Terbuka',
                                value: state.result.spkTerbuka.toString(),
                                labelSize: 12,
                                boxColor: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Row(
                          spacing: 4,
                          children: [
                            Expanded(
                              child: Widgets.buildStatBox(
                                context: context,
                                label: 'Approval',
                                value: state.result.spkApprove.toString(),
                                labelSize: 12,
                                boxColor: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Widgets.buildStatBox(
                                context: context,
                                label: '% Approval',
                                value:
                                    (state.result.spkApprove +
                                            state.result.spkReject) >
                                        0
                                    ? '${((state.result.spkApprove * 100 / (state.result.spkReject + state.result.spkApprove)).round())}%'
                                    : '-',
                                valueFontSize: 28,
                                labelSize: 12,
                                boxColor: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Widgets.buildStatBox(
                                context: context,
                                label: 'Reject',
                                value: state.result.spkReject.toString(),
                                labelSize: 12,
                                boxColor: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Widgets.buildStatBox(
                                context: context,
                                label: '% Reject',
                                value:
                                    (state.result.spkReject +
                                            state.result.spkApprove) >
                                        0
                                    ? '${((state.result.spkReject * 100 / (state.result.spkReject + state.result.spkApprove)).round())}%'
                                    : '-',
                                valueFontSize: 28,
                                labelSize: 12,
                                boxColor: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // ~:Jumlah SPK:~
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadowColor: Colors.grey,
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              spacing: 12,
                              children: [
                                // ~:Title:~
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Jumlah SPK',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                // ~:Data:~
                                Row(
                                  spacing: 4,
                                  children: [
                                    Expanded(
                                      child: Widgets.buildStatBox(
                                        context: context,
                                        label: '1 HARI',
                                        value:
                                            state.result.satuHari
                                                    .toString()
                                                    .isNotEmpty &&
                                                state.result.satuHari
                                                        .toString() !=
                                                    '0'
                                            ? state.result.satuHari.toString()
                                            : '-',
                                        valueFontSize: 28,
                                        labelSize: 12,
                                        boxColor: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Widgets.buildStatBox(
                                        context: context,
                                        label: '2 HARI',
                                        value:
                                            state.result.duaHari
                                                    .toString()
                                                    .isNotEmpty &&
                                                state.result.duaHari
                                                        .toString() !=
                                                    '0'
                                            ? state.result.duaHari.toString()
                                            : '-',
                                        valueFontSize: 28,
                                        labelSize: 12,
                                        boxColor: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Widgets.buildStatBox(
                                        context: context,
                                        label: '3 HARI',
                                        value:
                                            state.result.tigaHari
                                                    .toString()
                                                    .isNotEmpty &&
                                                state.result.tigaHari
                                                        .toString() !=
                                                    '0'
                                            ? state.result.tigaHari.toString()
                                            : '-',
                                        valueFontSize: 28,
                                        labelSize: 12,
                                        boxColor: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Widgets.buildStatBox(
                                        context: context,
                                        label: '> 3 HARI',
                                        value:
                                            state.result.lebihTigaHari
                                                    .toString()
                                                    .isNotEmpty &&
                                                state.result.lebihTigaHari
                                                        .toString() !=
                                                    '0'
                                            ? state.result.lebihTigaHari
                                                  .toString()
                                            : '-',
                                        valueFontSize: 28,
                                        labelSize: 12,
                                        boxColor: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ~:"Detail per Leasing" Table:~
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              spacing: 8,
                              children: [
                                // ~:Title:~
                                Text(
                                  'Detail per Leasing',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                // ~:Table:~
                                SizedBox(
                                  height: detailPerLeasingHeight,
                                  child: SfDataGrid(
                                    source: DetailPerLeasingDataSource(
                                      context: context,
                                      detailPerLeasingData:
                                          state.result.detail1,
                                    ),
                                    // onCellTap: (details) =>
                                    //     onFUCellTap(context, state, details),
                                    columnWidthMode: ColumnWidthMode.fill,
                                    horizontalScrollPhysics:
                                        const NeverScrollableScrollPhysics(),
                                    verticalScrollPhysics:
                                        const NeverScrollableScrollPhysics(),
                                    columns: [
                                      GridColumn(
                                        columnName: 'leasing',
                                        minimumWidth: 68,
                                        label: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Leasing',
                                            textAlign: TextAlign.center,
                                            style: TextThemes.normal.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'total',
                                        minimumWidth: 36,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'TTL',
                                            textAlign: TextAlign.center,
                                            style: TextThemes.normal.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'opened',
                                        minimumWidth: 36,
                                        label: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'P',
                                            textAlign: TextAlign.center,
                                            style: TextThemes.normal.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'approved',
                                        minimumWidth: 32,
                                        label: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'A',
                                            textAlign: TextAlign.center,
                                            style: TextThemes.normal.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'rejectedPercent',
                                        minimumWidth: 48,
                                        label: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'A%',
                                            textAlign: TextAlign.center,
                                            style: TextThemes.normal.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'con',
                                        minimumWidth: 48,
                                        label: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'CON',
                                            textAlign: TextAlign.center,
                                            style: TextThemes.normal.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'rejected',
                                        minimumWidth: 36,
                                        label: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'R',
                                            textAlign: TextAlign.center,
                                            style: TextThemes.normal.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
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

                        // ~:"Detail per Kategori" Table:~
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              spacing: 8,
                              children: [
                                // ~:Title:~
                                Text(
                                  'Detail per Kategori',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                // ~:Table:~
                                SizedBox(
                                  height: detailPerCategoryHeight,
                                  child: SfDataGrid(
                                    source: DetailPerCategoryDataSource(
                                      context: context,
                                      detailPerCategoryData:
                                          state.result.detail2,
                                    ),
                                    columnWidthMode: ColumnWidthMode.fill,
                                    horizontalScrollPhysics:
                                        const NeverScrollableScrollPhysics(),
                                    verticalScrollPhysics:
                                        const NeverScrollableScrollPhysics(),
                                    columns: [
                                      GridColumn(
                                        columnName: 'category',
                                        minimumWidth: 80,
                                        label: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Kategori',
                                            textAlign: TextAlign.center,
                                            style: TextThemes.normal.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'total',
                                        minimumWidth: 36,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'TTL',
                                            textAlign: TextAlign.center,
                                            style: TextThemes.normal.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'opened',
                                        minimumWidth: 36,
                                        label: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'P',
                                            textAlign: TextAlign.center,
                                            style: TextThemes.normal.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'approved',
                                        minimumWidth: 36,
                                        label: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'A',
                                            textAlign: TextAlign.center,
                                            style: TextThemes.normal.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'approvedPercent',
                                        minimumWidth: 36,
                                        label: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'A%',
                                            textAlign: TextAlign.center,
                                            style: TextThemes.normal.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'con',
                                        minimumWidth: 36,
                                        label: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'CON',
                                            textAlign: TextAlign.center,
                                            style: TextThemes.normal.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'rejected',
                                        minimumWidth: 36,
                                        label: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'R',
                                            textAlign: TextAlign.center,
                                            style: TextThemes.normal.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
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

                        // ~:"Detail Reject" Table:~
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              spacing: 8,
                              children: [
                                // ~:Title:~
                                Text(
                                  'Detail Reject',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                // ~:Table:~
                                SizedBox(
                                  height: detailRejectHeight,
                                  child: SfDataGrid(
                                    source: DetailRejectDataSource(
                                      context: context,
                                      detailRejectData: state.result.detail3,
                                      rejectedSpk: state.result.spkReject,
                                    ),
                                    columnWidthMode: ColumnWidthMode.fill,
                                    horizontalScrollPhysics:
                                        const NeverScrollableScrollPhysics(),
                                    verticalScrollPhysics:
                                        const NeverScrollableScrollPhysics(),
                                    columns: [
                                      GridColumn(
                                        columnName: 'reason',
                                        minimumWidth: 200,
                                        label: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Alasan',
                                            textAlign: TextAlign.center,
                                            style: TextThemes.normal.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'total',
                                        minimumWidth: 16,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'TTL',
                                            textAlign: TextAlign.center,
                                            style: TextThemes.normal.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'con',
                                        minimumWidth: 16,
                                        label: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'CON',
                                            textAlign: TextAlign.center,
                                            style: TextThemes.normal.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
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
                      ],
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
