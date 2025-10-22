import 'package:sip_sales_clean/data/models/salesman.dart';

abstract class SalesmanState {}

class SalesmanInit extends SalesmanState {}

class SalesmanLoading extends SalesmanState {}

class SalesmanAttendanceSuccess extends SalesmanState {
  final List<SalesmanAttendanceModel> data;

  SalesmanAttendanceSuccess(this.data);
}

class SalesmanAttendanceFailed extends SalesmanState {
  final String message;

  SalesmanAttendanceFailed(this.message);
}

class SalesmanDashboardLoading extends SalesmanState {}

class SalesmanDashboardSuccess extends SalesmanState {
  final List<SalesmanDashboardModel> data;

  SalesmanDashboardSuccess(this.data);
}

class SalesmanDashboardFailed extends SalesmanState {
  final String message;

  SalesmanDashboardFailed(this.message);
}
