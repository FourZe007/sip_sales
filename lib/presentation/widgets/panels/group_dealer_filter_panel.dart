import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/cubit/spk_leasing_filter_cubit.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';

class GroupDealerFilterPanel extends StatefulWidget {
  const GroupDealerFilterPanel({super.key});

  @override
  State<GroupDealerFilterPanel> createState() => _GroupDealerFilterPanelState();
}

class _GroupDealerFilterPanelState extends State<GroupDealerFilterPanel> {
  String isActive = 'Semua';

  void setIsActive(String value) {
    setState(() {
      isActive = value;
    });
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
              spacing: 8,
              children: [
                Text(
                  'Grup Dealer',
                  style: TextThemes.normal.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: state.groupDealerList.map((e) {
                    // context.read<SpkLeasingFilterCubit>().loadFilterData(
                    //   selectedGroupDealer: e.groupName,
                    // );
                    return FilterChip(
                      label: Text(e.groupName),
                      backgroundColor: isActive == e.groupName
                          ? Colors.blue[50]
                          : Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(
                        color: isActive == e.groupName
                            ? Colors.blue
                            : Colors.transparent,
                        width: 1.5,
                      ),
                      onSelected: (value) => setIsActive(e.groupName),
                      onDeleted: () => setIsActive(''),
                    );
                  }).toList(),
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
