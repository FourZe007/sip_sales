import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/cubit/spk_leasing_filter_cubit.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

class SpkLeasingPanel extends StatefulWidget {
  const SpkLeasingPanel({super.key});

  @override
  State<SpkLeasingPanel> createState() => _SpkLeasingPanelState();
}

class _SpkLeasingPanelState extends State<SpkLeasingPanel> {
  String date = DateTime.now().toIso8601String().substring(0, 10);

  void setDate(String x) {
    setState(() {
      date = x;
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
      child: Column(
        children: [
          // ~:Title:~
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Filter',
              style: TextThemes.normal.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ~:Body:~
          // ~:Month & Year Picker:~
          Row(
            children: [
              // ~:Month Picker:~
              ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(date),
                    currentDate: DateTime.parse(date),
                    firstDate: DateTime(1990),
                    lastDate: DateTime.now(),
                  );

                  if (picked != null && context.mounted) {
                    log('Selected date: ${picked.toString()}');
                    context.read<SpkLeasingFilterCubit>().changeFilter(
                      date: date,
                    );
                  }
                },
                child: Text(
                  date,
                  style: TextThemes.normal,
                ),
              ),
            ],
          ),

          // ~:Apply Button:~
          BlocBuilder<SpkLeasingFilterCubit, SpkLeasingFilterState>(
            buildWhen: (previous, current) =>
                current is SpkLeasingFilterApplied,
            builder: (context, state) {
              log('SpkLeasingFilterCubit state: $state');
              if (state is SpkLeasingFilterApplied) {
                return AnimatedContainer(
                  duration: Duration(seconds: 10),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromWidth(
                        MediaQuery.of(context).size.width,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Simpan',
                      style: TextThemes.normal,
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
