import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/data/models/employee.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/cubit/spk_leasing_data_cubit.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sip_sales_clean/presentation/widgets/templates/widgets.dart';

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
    final date = DateTime.now().toIso8601String().substring(0, 10);

    context.read<SpkLeasingDataCubit>().loadData(
      employee.employeeID,
      date,
      "${employee.branch}${employee.shop}",
      '',
      '',
      '',
    );
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
                    (context.read<LoginBloc>().state as LoginSuccess).user,
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
                              '${((state.result.spkApprove * 100 / (state.result.spkReject + state.result.spkApprove)).round())}%',
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
                              '${((state.result.spkReject * 100 / (state.result.spkReject + state.result.spkApprove)).round())}%',
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
                                          state.result.satuHari.toString() !=
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
                                          state.result.duaHari.toString() != '0'
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
                                          state.result.tigaHari.toString() !=
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
                                      ? state.result.lebihTigaHari.toString()
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
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Detail per Leasing',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ~:"Detail per Kategori" Table:~
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Detail per Kategori',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ~:"Detail Reject" Table:~
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Detail Reject',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
