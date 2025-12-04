import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/act_types.dart';
import 'package:sip_sales_clean/presentation/blocs/leasing_table/leasing_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/leasing_table/leasing_event.dart';
import 'package:sip_sales_clean/presentation/blocs/payment_table/payment_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/payment_table/payment_event.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman_table/salesman_table_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman_table/salesman_table_event.dart';
import 'package:sip_sales_clean/presentation/blocs/stu_table/stu_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/stu_table/stu_event.dart';
import 'package:sip_sales_clean/presentation/cubit/counter_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/dashboard_slidingup_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/head_act_types.dart';
import 'package:sip_sales_clean/presentation/screens/create_briefing_screen.dart';
import 'package:sip_sales_clean/presentation/screens/create_interview_screen.dart';
import 'package:sip_sales_clean/presentation/screens/create_recruitment_screen.dart';
import 'package:sip_sales_clean/presentation/screens/create_report_screen.dart';
import 'package:sip_sales_clean/presentation/screens/create_visit_screen.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

class NewActPanel extends StatefulWidget {
  const NewActPanel({super.key});

  @override
  State<NewActPanel> createState() => _NewActPanelState();
}

class _NewActPanelState extends State<NewActPanel> {
  void openCreationScreen(
    BuildContext context,
    HeadActTypesModel actTypes,
  ) async {
    final actName = actTypes.activityName.toLowerCase();
    if (actName.contains('briefing')) {
      // ~:Reset all required data for new form:~
      context.read<CounterCubit>().setInitial('total', 1);
      context.read<CounterCubit>().setInitial(
        'shop_manager',
        1,
      );
      context.read<CounterCubit>().setInitial(
        'sales_counter',
        1,
      );
      context.read<CounterCubit>().setInitial('salesman', 1);
      context.read<CounterCubit>().setInitial('others', 1);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateBriefingScreen(),
        ),
      );
    } else if (actName.contains('visit')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateVisitScreen(),
        ),
      );
    } else if (actName.contains('recruitment')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateRecruitmentScreen(),
        ),
      );
    } else if (actName.contains('interview')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateInterviewScreen(),
        ),
      );
    } else if (actName.contains('report')) {
      context.read<StuBloc>().add(ResetStuData());
      context.read<PaymentBloc>().add(ResetPaymentData());
      context.read<LeasingBloc>().add(ResetLeasingData());
      log('Salesman data is empty, fetching...');
      context.read<SalesmanTableBloc>().add(FetchSalesman());
      // context.read<ReportBloc>().add(InitiateReport());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateReportScreen(),
        ),
      );
    }
    context.read<DashboardSlidingUpCubit>().closePanel();
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
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      child: Column(
        spacing: 8,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 24,
            padding: EdgeInsets.only(left: 16, top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Buat Laporan / Tambah Data',
                  style: TextThemes.normal.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(
                  onPressed: () async =>
                      context.read<DashboardSlidingUpCubit>().closePanel(),
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  iconSize: 20,
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              children: context
                  .read<HeadActTypesCubit>()
                  .getActTypes()
                  .asMap()
                  .entries
                  .map((
                    e,
                  ) {
                    final index = e.key;
                    final actTypes = e.value;

                    if (index == 0) {
                      return DefaultTextStyle(
                        style: TextThemes.normalTextButton,
                        child: GestureDetector(
                          onTap: () => openCreationScreen(context, actTypes),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              Formatter.toTitleCase(actTypes.activityName),
                              style: TextThemes.normal.copyWith(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          const Divider(height: 0.5),

                          DefaultTextStyle(
                            style: TextThemes.normalTextButton,
                            child: GestureDetector(
                              onTap: () =>
                                  openCreationScreen(context, actTypes),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  Formatter.toTitleCase(actTypes.activityName),
                                  style: TextThemes.normal.copyWith(
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  })
                  .toList(),
            ),
          ),
          // Expanded(
          //   child: Column(
          //     children: [
          //       DefaultTextStyle(
          //         style: TextThemes.normalTextButton,
          //         child: GestureDetector(
          //           onTap: () {},
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 50,
          //             alignment: Alignment.center,
          //             decoration: BoxDecoration(
          //               color: Colors.transparent,
          //               borderRadius: BorderRadius.circular(20),
          //             ),
          //             child: Text('Morning Briefing'),
          //           ),
          //         ),
          //       ),
          //
          //       const Divider(height: 0.5),
          //
          //       DefaultTextStyle(
          //         style: TextThemes.normalTextButton,
          //         child: GestureDetector(
          //           onTap: () {},
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 50,
          //             alignment: Alignment.center,
          //             decoration: BoxDecoration(
          //               color: Colors.transparent,
          //               borderRadius: BorderRadius.circular(20),
          //             ),
          //             child: Text('Visit Market'),
          //           ),
          //         ),
          //       ),
          //
          //       const Divider(height: 0.5),
          //
          //       DefaultTextStyle(
          //         style: TextThemes.normalTextButton,
          //         child: GestureDetector(
          //           onTap: () {},
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 50,
          //             alignment: Alignment.center,
          //             decoration: BoxDecoration(
          //               color: Colors.transparent,
          //               borderRadius: BorderRadius.circular(20),
          //             ),
          //             child: Text('Recruitment'),
          //           ),
          //         ),
          //       ),
          //
          //       const Divider(height: 0.5),
          //
          //       DefaultTextStyle(
          //         style: TextThemes.normalTextButton,
          //         child: GestureDetector(
          //           onTap: () {},
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 50,
          //             alignment: Alignment.center,
          //             decoration: BoxDecoration(
          //               color: Colors.transparent,
          //               borderRadius: BorderRadius.circular(20),
          //             ),
          //             child: Text('Interview'),
          //           ),
          //         ),
          //       ),
          //
          //       const Divider(height: 0.5),
          //
          //       DefaultTextStyle(
          //         style: TextThemes.normalTextButton,
          //         child: GestureDetector(
          //           onTap: () {},
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 50,
          //             alignment: Alignment.center,
          //             decoration: BoxDecoration(
          //               color: Colors.transparent,
          //               borderRadius: BorderRadius.circular(20),
          //             ),
          //             child: Text('Daily Report'),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
