import 'package:sip_sales_clean/core/constant/enum.dart';

abstract class UpdateFollowupDashboardEvent {}

class InitUpdateFollowupResults extends UpdateFollowupDashboardEvent {}

// ~:Dropdown FU Results:~
class SelectUpdateFollowupResults extends UpdateFollowupDashboardEvent {
  final FollowUpResults results;
  final int index;

  SelectUpdateFollowupResults(this.results, this.index);
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

class SaveUpdateFollowup extends UpdateFollowupDashboardEvent {
  final String salesmanId;
  final String mobilePhone;
  final String prospectDate;
  final int line;
  final String fuDate;
  final String fuResult;
  final String fuMemo;
  final String nextFUDate;

  SaveUpdateFollowup(
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
