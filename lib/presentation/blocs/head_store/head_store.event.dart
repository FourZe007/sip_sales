import 'package:flutter/material.dart';
import 'package:sip_sales_clean/data/models/employee.dart';
import 'package:sip_sales_clean/presentation/cubit/image_cubit.dart';

abstract class HeadStoreEvent {
  final String employeeID;
  final String activityID;

  HeadStoreEvent({
    required this.employeeID,
    required this.activityID,
  });
}

class LoadHeadDashboard extends HeadStoreEvent {
  final String date;

  LoadHeadDashboard({
    required super.employeeID,
    super.activityID = '',
    required this.date,
  });
}

class LoadHeadActs extends HeadStoreEvent {
  final String date;

  LoadHeadActs({
    required super.employeeID,
    super.activityID = '',
    required this.date,
  });
}

class LoadHeadActsDetail extends HeadStoreEvent {
  final String date;

  LoadHeadActsDetail({
    required super.employeeID,
    required this.date,
    required super.activityID,
  });
}

class InsertMorningBriefing extends HeadStoreEvent {
  final BuildContext context;
  // final EmployeeModel employee;
  final String actId;
  final String desc;
  // final ImageState img;
  // final String locationName;
  // final List<int> values;

  InsertMorningBriefing({
    super.employeeID = '',
    super.activityID = '',
    required this.context,
    required this.actId,
    required this.desc,
    // required this.img,
    // required this.locationName,
    // required this.values,
  });

  get user => null;
}

class InsertVisitMarket extends HeadStoreEvent {
  final EmployeeModel employee;
  final String actId;
  final String desc;
  final ImageState img;
  final String locationName;
  final List<int> values;

  InsertVisitMarket({
    super.employeeID = '',
    super.activityID = '',
    required this.employee,
    required this.actId,
    required this.desc,
    required this.img,
    required this.locationName,
    required this.values,
  });

  get user => null;
}

class InsertRecruitment extends HeadStoreEvent {
  final EmployeeModel employee;
  final String actId;
  final String desc;
  final ImageState img;
  final String locationName;
  final List<int> values;

  InsertRecruitment({
    super.employeeID = '',
    super.activityID = '',
    required this.employee,
    required this.actId,
    required this.desc,
    required this.img,
    required this.locationName,
    required this.values,
  });

  get user => null;
}

class InsertInterview extends HeadStoreEvent {
  final EmployeeModel employee;
  final String actId;
  final String desc;
  final ImageState img;
  final String locationName;
  final List<int> values;

  InsertInterview({
    super.employeeID = '',
    super.activityID = '',
    required this.employee,
    required this.actId,
    required this.desc,
    required this.img,
    required this.locationName,
    required this.values,
  });

  get user => null;
}

class InsertDailyReport extends HeadStoreEvent {
  final EmployeeModel employee;
  final String actId;
  final String desc;
  final ImageState img;
  final String locationName;
  final List<int> values;

  InsertDailyReport({
    super.employeeID = '',
    super.activityID = '',
    required this.employee,
    required this.actId,
    required this.desc,
    required this.img,
    required this.locationName,
    required this.values,
  });

  get user => null;
}

class DeleteHeadActs extends HeadStoreEvent {
  final String date;

  DeleteHeadActs({
    required super.employeeID,
    required super.activityID,
    required this.date,
  });
}
