import 'package:flutter/material.dart';
import 'package:sip_sales_clean/data/models/employee.dart';

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
  final EmployeeModel employee;
  final String date;

  LoadHeadActsDetail({
    required this.date,
    required this.employee,
    super.employeeID = '',
    super.activityID = '',
  });
}

class InsertMorningBriefing extends HeadStoreEvent {
  final BuildContext context;
  // final EmployeeModel employee;
  final String actId;
  final String topic;
  // final ImageState img;
  // final String locationName;
  // final List<int> values;

  InsertMorningBriefing({
    super.employeeID = '',
    super.activityID = '',
    required this.context,
    required this.actId,
    required this.topic,
    // required this.img,
    // required this.locationName,
    // required this.values,
  });

  get user => null;
}

class InsertVisitMarket extends HeadStoreEvent {
  final BuildContext context;
  final String locationName;
  final String actTypeName;
  final String unitDisplay;
  final String unitTest;

  InsertVisitMarket({
    super.employeeID = '',
    super.activityID = '',
    required this.context,
    required this.locationName,
    required this.actTypeName,
    required this.unitDisplay,
    required this.unitTest,
  });
}

class InsertRecruitment extends HeadStoreEvent {
  final BuildContext context;
  final String media;
  final String position;

  InsertRecruitment({
    super.employeeID = '',
    super.activityID = '',
    required this.context,
    required this.media,
    required this.position,
  });

  get user => null;
}

class InsertInterview extends HeadStoreEvent {
  final BuildContext context;
  InsertInterview({
    super.employeeID = '',
    super.activityID = '',
    required this.context,
  });

  get user => null;
}

class InsertDailyReport extends HeadStoreEvent {
  final BuildContext context;
  // final List<HeadStuCategoriesMasterModel> categoriesList;
  // final List<HeadPaymentMasterModel> paymentList;
  // final List<HeadLeasingMasterModel> leasingList;
  // final List<HeadEmployeeMasterModel> employeeList;

  InsertDailyReport({
    super.employeeID = '',
    super.activityID = '',
    required this.context,
    // required this.categoriesList,
    // required this.paymentList,
    // required this.leasingList,
    // required this.employeeList,
  });

  get user => null;
}

class DeleteHeadActs extends HeadStoreEvent {
  final EmployeeModel employee;
  final String date;

  DeleteHeadActs({
    super.employeeID = '',
    super.activityID = '',
    required this.employee,
    required this.date,
  });
}
