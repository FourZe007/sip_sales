// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/cubit/attendance_type_cubit.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

class SalesmanAttandanceTypeDropdown extends StatefulWidget {
  const SalesmanAttandanceTypeDropdown({super.key});

  @override
  State<SalesmanAttandanceTypeDropdown> createState() =>
      _SalesmanAttandanceTypeDropdownState();
}

class _SalesmanAttandanceTypeDropdownState
    extends State<SalesmanAttandanceTypeDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: BlocBuilder<AttendanceTypeCubit, String>(
        builder: (context, state) {
          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(20),
              isExpanded: true,
              isDense: true,
              iconEnabledColor: Colors.black,
              dropdownColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20),
              value: state,
              icon: const Icon(
                Icons.arrow_drop_down_rounded,
                size: 28,
              ),
              items:
                  [
                    (context.read<LoginBloc>().state as LoginSuccess)
                        .user
                        .locationName,
                    'EVENT',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        Formatter.toTitleCase(value),
                        style: TextThemes.normal.copyWith(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
              onChanged: (String? newValue) async {
                context.read<AttendanceTypeCubit>().changeType(newValue!);
              },
            ),
          );
        },
      ),
    );
  }
}
