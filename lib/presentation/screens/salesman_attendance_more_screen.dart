import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman/salesman_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman/salesman_event.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman/salesman_state.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/buttons/attendance_list.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';

class SalesmanAttendanceMoreScreen extends StatefulWidget {
  const SalesmanAttendanceMoreScreen({required this.salesmanId, super.key});

  final String salesmanId;

  @override
  State<SalesmanAttendanceMoreScreen> createState() =>
      _SalesmanAttendanceMoreScreenState();
}

class _SalesmanAttendanceMoreScreenState
    extends State<SalesmanAttendanceMoreScreen> {
  // String date =
  //     '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 7)))} - ${DateFormat('yyyy-MM-dd').format(DateTime.now())}';
  // String startDate = DateFormat(
  //   'yyyy-MM-dd',
  // ).format(DateTime.now().subtract(const Duration(days: 7)));
  // String endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String startDate = 'Tgl Awal';
  String endDate = 'Tgl Akhir';

  void setStartDate(
    BuildContext context,
    String date,
  ) async {
    date = date == 'Tgl Awal'
        ? DateTime.now().toIso8601String().substring(0, 10)
        : date;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 7)),
      currentDate: DateTime.now().subtract(const Duration(days: 7)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    log(pickedDate.toString());

    if (pickedDate != null) {
      setState(() {
        startDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });

      if (context.mounted &&
          startDate != 'Tgl Awal' &&
          endDate != 'Tgl Akhir') {
        log('Load Data');
        context.read<SalesmanBloc>().add(
          SalesmanButtonPressed(
            salesmanId: widget.salesmanId,
            startDate: startDate,
            endDate: endDate,
          ),
        );
      } else {
        log('Skip Load Data');
      }
    }
  }

  void setEndDate(
    BuildContext context,
    String date,
  ) async {
    date = date == 'Tgl Akhir'
        ? DateTime.now().toIso8601String().substring(0, 10)
        : date;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      currentDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    log(pickedDate.toString());

    if (pickedDate != null) {
      setState(() {
        endDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });

      if (context.mounted &&
          startDate != 'Tgl Awal' &&
          endDate != 'Tgl Akhir') {
        log('Load Data');
        context.read<SalesmanBloc>().add(
          SalesmanButtonPressed(
            salesmanId: widget.salesmanId,
            startDate: startDate,
            endDate: endDate,
          ),
        );
      } else {
        log('Skip Load Data');
      }
    }
  }

  void refreshDashboard(
    BuildContext context,
    String salesmanId, {
    bool sortByName = false,
  }) {
    final date = DateTime.now().toIso8601String().substring(0, 10);
    log('Salesman Id: $salesmanId');
    log('Date: $date');

    log('Refresh Salesman Home Screen');
    context.read<SalesmanBloc>().add(
      SalesmanButtonPressed(
        salesmanId: salesmanId,
        startDate: '',
        endDate: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      maintainBottomViewPadding: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          toolbarHeight: 60,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          shadowColor: Colors.blue,
          centerTitle: true,
          titleSpacing: 16,
          title: Text(
            'Daftar Absensi',
            style: TextThemes.normal.copyWith(fontSize: 16),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Platform.isIOS
                  ? Icons.arrow_back_ios_new_rounded
                  : Icons.arrow_back_rounded,
              size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => refreshDashboard(context, widget.salesmanId),
              icon: Icon(
                Icons.refresh_rounded,
                size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                color: Colors.black,
              ),
            ),
          ],
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
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: BlocBuilder<SalesmanBloc, SalesmanState>(
              buildWhen: (previous, current) =>
                  current is SalesmanLoading ||
                  current is SalesmanAttendanceSuccess ||
                  current is SalesmanAttendanceFailed,
              builder: (context, state) {
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
                } else if (state is SalesmanAttendanceFailed) {
                  return Center(
                    child: Text(state.message),
                  );
                } else if (state is SalesmanAttendanceSuccess) {
                  return Column(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ~:Filter Section:~
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.05,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          child: Row(
                            spacing: 4,
                            children: [
                              // ~:Filter Icon:~
                              InkWell(
                                onTap: null,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: const Icon(
                                    Icons.filter_alt_rounded,
                                    size: 30.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),

                              // ~:Start Date Picker:~
                              InkWell(
                                onTap: () => setStartDate(context, startDate),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    startDate,
                                    style: TextThemes.normal.copyWith(
                                      fontSize: 20,
                                      color: startDate == 'Tgl Awal'
                                          ? Colors.grey[700]
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),

                              // ~:End Date Picker:~
                              InkWell(
                                onTap: () => setEndDate(context, endDate),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    endDate,
                                    style: TextThemes.normal.copyWith(
                                      fontSize: 20,
                                      color: endDate == 'Tgl Akhir'
                                          ? Colors.grey[700]
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ~:Attendance List:~
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.data.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return AttendanceList(
                              attendanceData: state.data[index],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
