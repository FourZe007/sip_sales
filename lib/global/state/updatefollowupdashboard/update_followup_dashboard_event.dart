abstract class UpdateFollowupDashboardEvent {}

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
