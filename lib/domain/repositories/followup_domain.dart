abstract class FollowupRepo {
  Future<Map<String, dynamic>> fetchFollowupDashboard(
    String salesmanId,
    String date,
    bool sortByName,
  );

  Future<Map<String, dynamic>> fetchFollowupDealDashboard(
    String salesmanId,
    String date,
    bool sortByName,
  );
}
