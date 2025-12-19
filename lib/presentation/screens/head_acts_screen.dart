// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/core/constant/enum.dart';
import 'package:sip_sales_clean/core/helpers/formatter.dart';
import 'package:sip_sales_clean/data/models/employee.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store.event.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_state.dart';
import 'package:sip_sales_clean/presentation/cubit/dashboard_slidingup_cubit.dart';
import 'package:sip_sales_clean/presentation/screens/head_acts_detail_screen.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/cards/head_card.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';

class HeadActivityPage extends StatefulWidget {
  const HeadActivityPage({required this.employeeModel, super.key});

  final EmployeeModel employeeModel;

  @override
  State<HeadActivityPage> createState() => _HeadActivityPageState();
}

class _HeadActivityPageState extends State<HeadActivityPage> {
  String date = DateTime.now().toString().split(' ')[0];
  bool isDateInit = false;

  void setDate(String value) {
    date = value;
  }

  void setSelectDate(
    BuildContext context,
    String tgl,
    Function handle, {
    bool isStart = false,
    bool isEnd = false,
  }) async {
    tgl = tgl == '' ? DateTime.now().toString().substring(0, 10) : tgl;

    DateTime? picked = await showDatePicker(
      context: context,
      currentDate: DateTime.parse(tgl),
      initialDate: DateTime.parse(tgl),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != DateTime.parse(tgl)) {
      setState(() {
        tgl = picked.toString().substring(0, 10);
      });
      handle(tgl);
      log('Fetch Data');

      context.read<HeadStoreBloc>().add(
        LoadHeadActs(
          employeeID: widget.employeeModel.employeeID,
          date: tgl,
        ),
      );
    }
  }

  @override
  void initState() {
    // toggleIsDateInit();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget activityView(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.73,
      alignment: Alignment.center,
      child: BlocBuilder<HeadStoreBloc, HeadStoreState>(
        buildWhen: (previous, current) =>
            (current is HeadStoreLoading &&
                current.isActs &&
                !current.isInsert &&
                !current.isDashboard) ||
            current is HeadStoreDataLoaded ||
            current is HeadStoreDataFailed,
        builder: (context, state) {
          if (state is HeadStoreLoading) {
            if (Platform.isIOS) {
              return const CupertinoActivityIndicator(
                radius: 8,
                color: Colors.black,
              );
            } else {
              return const AndroidLoading(
                warna: Colors.black,
                strokeWidth: 3,
              );
            }
          } else if (state is HeadStoreDataFailed) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is HeadStoreDataLoaded) {
            return ListView(
              physics: NeverScrollableScrollPhysics(),
              children: state.headActs.asMap().entries.map((e) {
                final int i = e.key;
                final HeadActsModel data = e.value;

                IconData icon;
                switch (data.activityId) {
                  case '00':
                    icon = Icons.flare_rounded;
                    break;
                  case '01':
                    icon = Icons.shopping_bag_rounded;
                    break;
                  case '02':
                    icon = Icons.find_in_page_rounded;
                    break;
                  case '03':
                    icon = Icons.note_rounded;
                    break;
                  case '04':
                    icon = Icons.event_note_rounded;
                    break;
                  default:
                    icon = Icons.question_mark_rounded;
                }

                return Column(
                  spacing: 8,
                  children: [
                    // ~:Branch:~
                    Builder(
                      builder: (context) {
                        if (i == 0) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cabang: ',
                                  style: TextThemes.normal.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    Formatter.toCompanyAbbForm(data.shopName),
                                    style: TextThemes.normal.copyWith(
                                      fontSize: 20,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),

                    // ~:Card:~
                    HeadTasksCard(
                      icon: icon,
                      title: data.activityName,
                      time: data.time,
                      onTap: () {
                        context.read<HeadStoreBloc>().add(
                          LoadHeadActsDetail(
                            employeeID: widget.employeeModel.employeeID,
                            date: date,
                            activityID: data.activityId,
                          ),
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HeadActDetailScreen(),
                          ),
                        );
                      },
                      onDelete: () {
                        // ~:toggling panel:~
                        log('Toggle to open delete panel');
                        context.read<DashboardSlidingUpCubit>().changeType(
                          DashboardSlidingUpType.deleteManagerActivity,
                          data: data.activityId,
                        );
                      },
                    ),
                  ],
                );
              }).toList(),
            );
          } else {
            return const Center(
              child: Text('Data Tidak Ditemukan'),
            );
          }
        },
      ),
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
      padding: EdgeInsets.fromLTRB(10, 20, 10, 8),
      child: Column(
        spacing: 12,
        children: [
          // ~:Filter Section:~
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.05,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Open Filter Button
                InkWell(
                  // onTap: toggleFilter,
                  onTap: null,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.black, width: 1.5),
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: const Icon(
                      Icons.filter_alt_rounded,
                      size: 30.0,
                      color: Colors.black,
                    ),
                  ),
                ),

                // Modify Begin Date
                InkWell(
                  onTap: () => setSelectDate(
                    context,
                    date,
                    setDate,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.black, width: 1.5),
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Tgl ${Formatter.dateFormat(date)}',
                      style: TextThemes.normal.copyWith(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ~:Body:~
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Builder(
                builder: (context) {
                  if (Platform.isIOS) {
                    return CustomScrollView(
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: () async =>
                              context.read<HeadStoreBloc>().add(
                                LoadHeadActs(
                                  employeeID: widget.employeeModel.employeeID,
                                  date: date,
                                ),
                              ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, _) => activityView(context),
                            childCount: 1,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: () async => context.read<HeadStoreBloc>().add(
                        LoadHeadActs(
                          employeeID: widget.employeeModel.employeeID,
                          date: date,
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: activityView(context),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
