import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales/global/global.dart';
import 'package:sip_sales/global/state/salesdashboard/sales_dashboard_bloc.dart';
import 'package:sip_sales/global/state/salesdashboard/sales_dashboard_state.dart';

class SalesDashboardScreen extends StatefulWidget {
  const SalesDashboardScreen({super.key});

  @override
  State<SalesDashboardScreen> createState() => _SalesDashboardScreenState();
}

class _SalesDashboardScreenState extends State<SalesDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Builder(
          builder: (context) {
            if (MediaQuery.of(context).size.width < 800) {
              return Text(
                'Dashboard',
                style: GlobalFont.giantfontRBold,
              );
            } else {
              return Text(
                'Dashboard',
                style: GlobalFont.terafontRBold,
              );
            }
          },
        ),
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (context) {
            if (Platform.isIOS) {
              return IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                  color: Colors.black,
                ),
              );
            } else {
              return IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                  color: Colors.black,
                ),
              );
            }
          },
        ),
      ),
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              color: Colors.white,
            ),
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.025,
              MediaQuery.of(context).size.height * 0.02,
              MediaQuery.of(context).size.width * 0.025,
              0.0,
            ),
            child: BlocBuilder<SalesDashboardBloc, SalesDashboardState>(
              builder: (context, state) {
                if (state is SalesDashboardLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SalesDashboardError) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (state is SalesDashboardLoaded) {
                  log('Sales length: ${state.salesData.length}');
                  return ListView.builder(
                    itemCount: state.salesData.length,
                    itemBuilder: (context, index) {
                      final salesData = state.salesData[index];
                      return ListTile(
                        title: Text(salesData.prospek.toString()),
                        subtitle: Text('Sales: ${salesData.spk.toString()}'),
                        trailing: Text('Target: ${salesData.stu.toString()}'),
                      );
                    },
                  );
                  // return Center(
                  //   child: Text(
                  //     'Data loaded successfully! ${state.salesData.length} items found.',
                  //     textAlign: TextAlign.center,
                  //   ),
                  // );
                } else {
                  return Center(
                    child: Text(
                      'No data available',
                      textAlign: TextAlign.center,
                    ),
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
