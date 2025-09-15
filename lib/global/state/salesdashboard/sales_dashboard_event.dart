// ...existing code...
abstract class SalesDashboardEvent {}

class LoadSalesDashboard extends SalesDashboardEvent {
  final String salesmanId;
  final String date;

  LoadSalesDashboard(this.salesmanId, this.date);
}

class LoadCoordinatorDashboard extends SalesDashboardEvent {
  final String salesmanId;
  final String date;

  LoadCoordinatorDashboard(this.salesmanId, this.date);
}
