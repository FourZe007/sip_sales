import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/cubit/dashboard_slidingup_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/spk_leasing_data_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/spk_leasing_filter_cubit.dart';
import 'package:sip_sales_clean/presentation/providers/filter_state_provider.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_ios_loading.dart';

class CategoryFilterPanel extends StatefulWidget {
  const CategoryFilterPanel({super.key});

  @override
  State<CategoryFilterPanel> createState() => _CategoryFilterPanelState();
}

class _CategoryFilterPanelState extends State<CategoryFilterPanel> {
  String isActive = 'Semua';

  void setIsActive(String value) {
    setState(() {
      isActive = value;
    });
  }

  @override
  void initState() {
    super.initState();

    if (context.read<FilterStateProvider>().selectedCategory.value.isNotEmpty &&
        context.read<FilterStateProvider>().selectedCategory.value != '') {
      setIsActive(context.read<FilterStateProvider>().selectedCategory.value);
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
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom,
      ),
      child: BlocBuilder<SpkLeasingFilterCubit, SpkLeasingFilterState>(
        builder: (context, state) {
          if (state is SpkLeasingFilterLoading) {
            return const AndroidIosLoading(
              indicatorColor: Colors.black,
              strokeWidth: 3,
              customizedHeight: 24,
              customizedWidth: 24,
              iosRadius: 12,
            );
          } else if (state is SpkLeasingFilterLoaded) {
            return Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilih salah satu jenis kategori',
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
                              children: state.categoryList.map((e) {
                                return FilterChip(
                                  label: Text(e.category),
                                  backgroundColor: isActive == e.category
                                      ? Colors.blue[50]
                                      : Colors.grey[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  side: BorderSide(
                                    color: isActive == e.category
                                        ? Colors.blue
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                  onSelected: (value) =>
                                      setIsActive(e.category),
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

                ValueListenableBuilder(
                  valueListenable: ValueNotifier(isActive),
                  builder: (context, value, _) {
                    if (value.isNotEmpty) {
                      return GestureDetector(
                        onTap: () {
                          log('Category Value: $value');
                          // ~:Close Sliding Panel:~
                          context.read<DashboardSlidingUpCubit>().closePanel();

                          context
                              .read<FilterStateProvider>()
                              .setSelectedCategory(
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
                              log('Selected dealer: $branchShop');
                              if (e.bsName.toLowerCase() ==
                                  branchShop.toLowerCase()) {
                                branchShop = '${e.branch}${e.shop}';
                                break;
                              }
                            }
                          } else {
                            branchShop = '${employee.branch}${employee.shop}';
                          }

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
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          padding: const EdgeInsets.all(4),
                          margin: EdgeInsets.symmetric(vertical: 4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Simpan',
                            style: TextThemes.normal.copyWith(
                              fontSize: 16,
                              color: Colors.white,
                            ),
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
