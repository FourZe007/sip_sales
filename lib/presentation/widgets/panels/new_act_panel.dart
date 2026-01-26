import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/act_types.dart';
import 'package:sip_sales_clean/presentation/blocs/leasing_table/leasing_table_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/leasing_table/leasing_table_event.dart';
import 'package:sip_sales_clean/presentation/blocs/payment_table/payment_table_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/payment_table/payment_table_event.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman_table/salesman_table_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/salesman_table/salesman_table_event.dart';
import 'package:sip_sales_clean/presentation/blocs/stu_table/stu_table_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/stu_table/stu_table_event.dart';
import 'package:sip_sales_clean/presentation/cubit/briefing_desc.dart';
import 'package:sip_sales_clean/presentation/cubit/counter_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/dashboard_slidingup_cubit.dart';
import 'package:sip_sales_clean/presentation/cubit/head_act_types.dart';
import 'package:sip_sales_clean/presentation/cubit/head_acts_master.dart';
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
    final headActsMaster = context.read<HeadActsMasterCubit>().state;
    // (context.read<HeadActsMasterCubit>().state is HeadActsMasterLoaded)
    //     ? (context.read<HeadActsMasterCubit>().state as HeadActsMasterLoaded)
    //     : (context.read<HeadActsMasterCubit>().state as HeadActsMasterFailed);
    log('Head Acts Master state: $headActsMaster');

    final actName = actTypes.activityName.toLowerCase();
    log('Activity Name: $actName');
    if (actName.contains('briefing')) {
      // ~:Reset all required data for new form:~
      context.read<CounterCubit>().setInitial(
        'shop_manager',
        (headActsMaster is HeadActsMasterLoaded)
            ? headActsMaster.briefingMaster[0].shopManager
            : 1,
      );
      context.read<CounterCubit>().setInitial(
        'sales_counter',
        (headActsMaster is HeadActsMasterLoaded)
            ? headActsMaster.briefingMaster[0].salesCounter
            : 1,
      );
      context.read<CounterCubit>().setInitial(
        'salesman',
        (headActsMaster is HeadActsMasterLoaded)
            ? headActsMaster.briefingMaster[0].salesman
            : 1,
      );
      context.read<CounterCubit>().setInitial(
        'others',
        (headActsMaster is HeadActsMasterLoaded)
            ? headActsMaster.briefingMaster[0].others
            : 1,
      );
      context.read<CounterCubit>().setInitial(
        'number_of_participants',
        (headActsMaster is HeadActsMasterLoaded)
            ? headActsMaster.briefingMaster[0].contestant
            : 1,
      );

      context.read<BriefingDescCubit>().resetFields();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateBriefingScreen(),
        ),
      );
    } else if (actName.contains('visit')) {
      context.read<CounterCubit>().setInitial('ttl_sales', 0);
      context.read<CounterCubit>().setInitial('db', 0);
      context.read<CounterCubit>().setInitial('hot_pros', 0);
      context.read<CounterCubit>().setInitial('deal', 0);
      context.read<CounterCubit>().setInitial('test_ride_participant', 0);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateVisitScreen(),
        ),
      );
    } else if (actName.contains('(') && actName.contains(')')) {
      final actNameWithoutParenthesis = actName.split(' ')[0];
      log('Activity Name Without Parenthesis: $actNameWithoutParenthesis');

      if (actNameWithoutParenthesis.contains('recruitment')) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateRecruitmentScreen(),
          ),
        );
      } else if (actNameWithoutParenthesis.contains('interview')) {
        // ~:Reset all required data for new form:~
        context.read<CounterCubit>().setInitial('total_itv', 0);
        context.read<CounterCubit>().setInitial('fb_itv', 0);
        context.read<CounterCubit>().setInitial('ig_itv', 0);
        context.read<CounterCubit>().setInitial('training_itv', 0);
        context.read<CounterCubit>().setInitial('cv_itv', 0);
        context.read<CounterCubit>().setInitial('other_itv', 0);
        context.read<CounterCubit>().setInitial('called', 0);
        context.read<CounterCubit>().setInitial('came', 0);
        context.read<CounterCubit>().setInitial('acc', 0);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateInterviewScreen(),
          ),
        );
      } else {
        log('Not considered as Recruitment or Interview');
      }
    } else if (actName.contains('report')) {
      if (context.read<HeadActsMasterCubit>().state is HeadActsMasterLoaded) {
        log('Load Report Data');
        context.read<StuTableBloc>().add(
          ResetStuData(
            (context.read<HeadActsMasterCubit>().state as HeadActsMasterLoaded)
                .reportMaster[0]
                .stuCategories,
          ),
        );
        context.read<PaymentTableBloc>().add(
          ResetPaymentData(
            (context.read<HeadActsMasterCubit>().state as HeadActsMasterLoaded)
                .reportMaster[0]
                .payment,
          ),
        );
        context.read<LeasingTableBloc>().add(
          ResetLeasingData(
            (context.read<HeadActsMasterCubit>().state as HeadActsMasterLoaded)
                .reportMaster[0]
                .spkLeasing,
          ),
        );
        context.read<SalesmanTableBloc>().add(
          ResetSalesman(
            (context.read<HeadActsMasterCubit>().state as HeadActsMasterLoaded)
                .reportMaster[0]
                .employee,
          ),
        );
      } else {
        log('Master data is not loaded');
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateReportScreen(),
        ),
      );
    } else {
      // log('Activity not found');
      final actName = actTypes.activityName.toLowerCase();
      log('Activity Name: $actName');
      if (actName.contains('briefing')) {
        // ~:Reset all required data for new form:~
        context.read<CounterCubit>().setInitial('shop_manager', 1);
        context.read<CounterCubit>().setInitial('sales_counter', 1);
        context.read<CounterCubit>().setInitial('salesman', 1);
        context.read<CounterCubit>().setInitial('others', 1);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateBriefingScreen(),
          ),
        );
      }
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
