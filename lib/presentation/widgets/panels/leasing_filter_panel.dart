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

class LeasingFilterPanel extends StatefulWidget {
  const LeasingFilterPanel({super.key});

  @override
  State<LeasingFilterPanel> createState() => _LeasingFilterPanelState();
}

class _LeasingFilterPanelState extends State<LeasingFilterPanel> {
  String isActive = 'Semua';

  void setIsActive(String value) {
    setState(() {
      isActive = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (context.read<FilterStateProvider>().selectedLeasing.value.isNotEmpty &&
        context.read<FilterStateProvider>().selectedLeasing.value != '') {
      setIsActive(context.read<FilterStateProvider>().selectedLeasing.value);
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
                          'Dealer',
                          style: TextThemes.normal.copyWith(
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
                              children: state.leasingList.map((e) {
                                return FilterChip(
                                  label: Text(e.leasingId),
                                  backgroundColor: isActive == e.leasingId
                                      ? Colors.blue[50]
                                      : Colors.grey[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  side: BorderSide(
                                    color: isActive == e.leasingId
                                        ? Colors.blue
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                  onSelected: (_) => setIsActive(e.leasingId),
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
                    if (value.isNotEmpty) {
                      return ElevatedButton(
                        onPressed: () {
                          // ~:Close Sliding Panel:~
                          context.read<DashboardSlidingUpCubit>().closePanel();

                          context
                              .read<FilterStateProvider>()
                              .setSelectedLeasing(value);

                          // ~:Get Employee Data:~
                          final employee =
                              (context.read<LoginBloc>().state as LoginSuccess)
                                  .user;

                          // ~:load new filter with a selected Group Dealer:~
                          // context.read<SpkLeasingFilterCubit>().loadFilterData(
                          //   selectedGroupDealer: value,
                          // );

                          // ~:load new data with a selected Group Dealer:~
                          context.read<SpkLeasingDataCubit>().loadData(
                            employee.employeeID,
                            context
                                .read<FilterStateProvider>()
                                .selectedDate
                                .value,
                            "${employee.branch}${employee.shop}", // employee data
                            context
                                .read<FilterStateProvider>()
                                .selectedCategory
                                .value, // category name
                            value, // leasing name
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
                    } else {
                      return SizedBox.shrink();
                    }
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
