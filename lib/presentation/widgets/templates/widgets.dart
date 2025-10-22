import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/shop_coordinator/shop_coordinator_bloc.dart';
import 'package:sip_sales_clean/presentation/blocs/shop_coordinator/shop_coordinator_event.dart';
import 'package:sip_sales_clean/presentation/screens/coordinator_dashboard_screen.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

class Widgets {
  static Widget shopCoordinatorBody(
    BuildContext context,
    String employeeId,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: (Platform.isIOS)
          ? CustomScrollView(
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () async =>
                      context.read<ShopCoordinatorBloc>().add(
                        LoadCoordinatorDashboard(
                          employeeId,
                          DateTime.now().toIso8601String().split(
                            'T',
                          )[0],
                        ),
                      ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, _) => CoordinatorDashboard(
                      employeeId: employeeId,
                    ),
                    childCount: 1,
                  ),
                ),
              ],
            )
          : RefreshIndicator(
              onRefresh: () async => context.read<ShopCoordinatorBloc>().add(
                LoadCoordinatorDashboard(
                  employeeId,
                  DateTime.now().toIso8601String().split(
                    'T',
                  )[0],
                ),
              ),
              child: CoordinatorDashboard(employeeId: employeeId),
            ),
    );
  }

  static Widget buildStatBox({
    required BuildContext context,
    required String label,
    required int value,
    double boxWidth = 64,
    double boxHeight = 75,
    double labelHeight = 20,
    double labelSize = 16,
    Color boxColor = Colors.amber,
  }) {
    return Container(
      width: boxWidth,
      height: boxHeight,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: labelHeight,
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextThemes.normal.copyWith(fontSize: labelSize),
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Text(
                value.toString(),
                style: TextThemes.normal.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
