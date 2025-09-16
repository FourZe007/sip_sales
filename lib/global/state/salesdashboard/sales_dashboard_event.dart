// ...existing code...
abstract class SalesDashboardEvent {}

class LoadSalesDashboard extends SalesDashboardEvent {
  final String salesmanId;
  final String date;

  LoadSalesDashboard(this.salesmanId, this.date);
}
