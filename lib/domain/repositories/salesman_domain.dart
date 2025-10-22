abstract class SalesmanRepo {
  Future<Map<String, dynamic>> loadAttendance(
    String salesmanId,
    String startDate,
    String endDate,
  );

  Future<Map<String, dynamic>> loadDashboard(
    String salesmanId,
    String endDate,
  );
}
