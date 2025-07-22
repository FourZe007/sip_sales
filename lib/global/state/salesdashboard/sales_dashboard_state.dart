// ...existing code...
import 'package:sip_sales/global/model.dart';

abstract class SalesDashboardState {}

class SalesDashboardInitial extends SalesDashboardState {}

class SalesDashboardLoading extends SalesDashboardState {}

class SalesDashboardLoaded extends SalesDashboardState {
  final List<SalesmanDashboardModel> salesData;

  SalesDashboardLoaded(this.salesData);
}

class SalesDashboardError extends SalesDashboardState {
  final String message;
  SalesDashboardError(this.message);
}
