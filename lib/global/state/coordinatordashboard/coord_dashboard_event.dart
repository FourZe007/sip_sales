// ...existing code...
abstract class CoordinatorDashboardEvent {}

class LoadCoordinatorDashboard extends CoordinatorDashboardEvent {
  final String salesmanId;
  final String date;

  LoadCoordinatorDashboard(this.salesmanId, this.date);
}
