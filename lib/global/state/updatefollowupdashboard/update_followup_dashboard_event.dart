import 'package:sip_sales/global/enum.dart';

abstract class UpdateFollowupDashboardEvent {}

class SelectUpdateFollowupStatus extends UpdateFollowupDashboardEvent {
  final FollowUpStatus status;

  SelectUpdateFollowupStatus(this.status);
}

class LoadUpdateFollowupDashboard extends UpdateFollowupDashboardEvent {
  final String salesmanId;
  final String mobilePhone;
  final String prospectDate;

  LoadUpdateFollowupDashboard(
    this.salesmanId,
    this.mobilePhone,
    this.prospectDate,
  );
}

class SaveUpdateFollowupStatus extends UpdateFollowupDashboardEvent {
  final String salesmanId;
  final String mobilePhone;
  final String prospectDate;
  final int line;
  final String fuDate;
  final String fuResult;
  final String fuMemo;
  final String nextFUDate;

  SaveUpdateFollowupStatus(
    this.salesmanId,
    this.mobilePhone,
    this.prospectDate,
    this.line,
    this.fuDate,
    this.fuResult,
    this.fuMemo,
    this.nextFUDate,
  );
}
