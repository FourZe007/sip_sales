abstract class SalesmanEvent {
  SalesmanEvent();
}

class SalesmanButtonPressed extends SalesmanEvent {
  final String salesmanId;
  final String startDate;
  final String endDate;

  SalesmanButtonPressed({
    required this.salesmanId,
    required this.startDate,
    required this.endDate,
  });
}

class SalesmanDashboardButtonPressed extends SalesmanEvent {
  final String salesmanId;
  final String endDate;

  SalesmanDashboardButtonPressed({
    required this.salesmanId,
    required this.endDate,
  });
}
