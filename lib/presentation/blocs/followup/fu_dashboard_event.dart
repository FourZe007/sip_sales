abstract class FollowupDashboardEvent {}

class LoadFollowupDashboard extends FollowupDashboardEvent {
  final String salesmanId;
  final String date;
  final bool sortByName;

  LoadFollowupDashboard(this.salesmanId, this.date, this.sortByName);
}

class LoadFollowupDealDashboard extends FollowupDashboardEvent {
  final String salesmanId;
  final String date;
  final bool sortByName;

  LoadFollowupDealDashboard(this.salesmanId, this.date, this.sortByName);
}
