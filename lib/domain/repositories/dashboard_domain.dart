abstract class DashboardRepo {
  Future<Map<String, dynamic>> fetchCoordinatorDashboard(
    String employeeId,
    String date,
  );
}
