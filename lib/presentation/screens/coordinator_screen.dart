import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sip_sales_clean/data/models/employee.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';
import 'package:sip_sales_clean/presentation/widgets/templates/user_profile.dart';
import 'package:sip_sales_clean/presentation/widgets/templates/widgets.dart';

class CoordinatorScreen extends StatelessWidget {
  const CoordinatorScreen({
    super.key,
    required this.applyUserProfile,
    this.employee,
    this.openProfile,
    this.employeeId,
  });

  final bool applyUserProfile;
  final EmployeeModel? employee;
  final VoidCallback? openProfile;
  final String? employeeId;

  @override
  Widget build(BuildContext context) {
    if (applyUserProfile) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.blue,
          toolbarHeight: 60,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          shadowColor: Colors.blue,
          leading: Material(
            color: Colors.transparent,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Platform.isIOS
                    ? Icons.arrow_back_ios_new_rounded
                    : Icons.arrow_back_rounded,
                size: (MediaQuery.of(context).size.width < 800) ? 20.0 : 35.0,
                color: Colors.black,
              ),
            ),
          ),
          centerTitle: true,
          titleSpacing: 16,
          title: Text(
            'Laporan Koordinator',
            style: TextThemes.normal.copyWith(
              fontSize: 16,
            ),
          ),
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Widgets.shopCoordinatorBody(
            context,
            employeeId!,
          ),
        ),
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          toolbarHeight: MediaQuery.of(context).size.height * 0.01,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          shadowColor: Colors.blue,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.blue,
          child: Column(
            children: [
              // ~:User Profile Section:~
              UserProfileTemplate(
                openProfile: openProfile!,
                employee: employee!,
              ),

              Expanded(
                child: Widgets.shopCoordinatorBody(
                  context,
                  employee!.employeeID,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
