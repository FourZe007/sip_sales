import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store.event.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/head_store/head_store_state.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/login/login_state.dart';
import 'package:sip_sales_clean/presentation/cubit/dashboard_slidingup_cubit.dart';
import 'package:sip_sales_clean/presentation/functions.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/indicator/android_loading.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HeadDeleteActsScreen extends StatelessWidget {
  const HeadDeleteActsScreen({
    required this.activityId,
    required this.panelController,
    super.key,
  });

  final String activityId;
  final PanelController panelController;

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
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ~:Header:~
          Column(
            spacing: 8,
            children: [
              // ~:Title:~
              Text(
                'Peringatan!',
                style: TextThemes.normal.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              // ~:Description:~
              Text(
                'Apakah anda yakin ingin menghapus aktivitas ini?',
                style: TextThemes.normal.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          // ~:Buttons:~
          Row(
            spacing: 12,
            children: [
              // ~:Cancel Button:~
              Expanded(
                child: ElevatedButton(
                  onPressed: () => panelController.close(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(
                        color: Colors.blue,
                        width: 3.0,
                      ),
                    ),
                  ),
                  child: Text(
                    'Batal',
                    style: TextThemes.normal,
                  ),
                ),
              ),

              // ~:Delete Button:~
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.read<HeadStoreBloc>().add(
                    DeleteHeadActs(
                      employeeID:
                          (context.read<LoginBloc>().state as LoginSuccess)
                              .user
                              .employeeID,
                      activityID: activityId,
                      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: BlocConsumer<HeadStoreBloc, HeadStoreState>(
                    listener: (context, state) {
                      if (state is HeadStoreDeleteSucceed) {
                        log('Deleted');
                        context.read<DashboardSlidingUpCubit>().closePanel();

                        Functions.customFlutterToast(
                          'Laporan berhasil dihapus!',
                        );

                        context.read<HeadStoreBloc>().add(
                          LoadHeadActs(
                            employeeID:
                                (context.read<LoginBloc>().state
                                        as LoginSuccess)
                                    .user
                                    .employeeID,
                            date: DateFormat('yyyy-MM-dd').format(
                              DateTime.now(),
                            ),
                          ),
                        );
                      } else if (state is HeadStoreDeleteFailed) {
                        log('Failed');
                        Functions.customFlutterToast(
                          state.message,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is HeadStoreLoading &&
                          state.isDelete &&
                          !state.isActs &&
                          !state.isActsDetail &&
                          !state.isDashboard &&
                          !state.isInsert) {
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
                      } else {
                        return Text(
                          'Hapus',
                          style: TextThemes.normalWhite,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
