// ...existing code...
abstract class ShopCoordinatorEvent {}

class LoadCoordinatorDashboard extends ShopCoordinatorEvent {
  final String salesmanId;
  final String date;

  LoadCoordinatorDashboard(this.salesmanId, this.date);
}
