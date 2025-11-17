import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/cubit/dashboard_slidingup_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/spk_leasing_data_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/spk_leasing_filter_cubit.dart';
import 'package:sip_sales_clean/presentation/providers/filter_state_provider.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';

class DealerFilterPanel extends StatefulWidget {
  const DealerFilterPanel({this.isSamsung = false, super.key});

  final bool isSamsung;

  @override
  State<DealerFilterPanel> createState() => DealerFilterPanelState();
}

class DealerFilterPanelState extends State<DealerFilterPanel> {
  String isActive = 'Semua';

  void setIsActive(String value) {
    setState(() {
      isActive = value;
    });
  }

  @override
  void initState() {
    super.initState();

    if (context.read<FilterStateProvider>().selectedDealer.value.isNotEmpty &&
        context.read<FilterStateProvider>().selectedDealer.value != '') {
      setIsActive(context.read<FilterStateProvider>().selectedDealer.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: BlocBuilder<SpkLeasingFilterCubit, SpkLeasingFilterState>(
        builder: (context, state) {
          if (state is SpkLeasingFilterLoading) {
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
          } else if (state is SpkLeasingFilterLoaded) {
            return Column(
              children: [
                // ~:Filter Options:~
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilih salah satu jenis dealer',
                          style: TextThemes.normal.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Expanded(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              alignment: WrapAlignment.start,
                              children: state.dealerList.map((e) {
                                return FilterChip(
                                  label: Text(e.bsName),
                                  backgroundColor: isActive == e.bsName
                                      ? Colors.blue[50]
                                      : Colors.grey[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  side: BorderSide(
                                    color: isActive == e.bsName
                                        ? Colors.blue
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                  onSelected: (value) => setIsActive(e.bsName),
                                  onDeleted: () => setIsActive(''),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ~:Apply Filter Button:~
                ValueListenableBuilder(
                  valueListenable: ValueNotifier(isActive),
                  builder: (context, value, _) {
                    return ElevatedButton(
                      onPressed: () {
                        log('Dealer Value: $value');
                        // ~:Close Sliding Panel:~
                        context.read<DashboardSlidingUpCubit>().closePanel();

                        context.read<FilterStateProvider>().setSelectedDealer(
                          value.toLowerCase() == 'semua' ? '' : value,
                        );

                        // ~:Get Employee Data:~
                        final employee =
                            (context.read<LoginBloc>().state as LoginSuccess)
                                .user;

                        String branchShop = context
                            .read<FilterStateProvider>()
                            .selectedDealer
                            .value;
                        if (branchShop != '' && branchShop != 'Semua') {
                          for (var e
                              in (context.read<SpkLeasingFilterCubit>().state
                                      as SpkLeasingFilterLoaded)
                                  .dealerList) {
                            log('Dealer name: ${e.bsName}');
                            log('Selected dealer: $value');
                            if (e.bsName.toLowerCase() == value.toLowerCase()) {
                              branchShop = '${e.branch}${e.shop}';
                              break;
                            }
                          }
                        } else {
                          branchShop = '${employee.branch}${employee.shop}';
                        }

                        // ~:load new data with a selected Group Dealer:~
                        context.read<SpkLeasingDataCubit>().loadData(
                          employee.employeeID,
                          context
                              .read<FilterStateProvider>()
                              .selectedDate
                              .value,
                          branchShop,
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
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromWidth(
                          MediaQuery.of(context).size.width,
                        ),
                        padding: EdgeInsets.all(4),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Simpan',
                        style: TextThemes.normal.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
