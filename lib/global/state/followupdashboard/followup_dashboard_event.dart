abstract class FollowupDashboardEvent {}

class LoadFollowupDashboard extends FollowupDashboardEvent {
  final String salesmanId;
  final String date;

  LoadFollowupDashboard(this.salesmanId, this.date);
}

class LoadFollowupDealDashboard extends FollowupDashboardEvent {
  final String salesmanId;
  final String date;

  LoadFollowupDealDashboard(this.salesmanId, this.date);
}
