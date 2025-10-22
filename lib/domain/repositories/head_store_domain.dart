abstract class HeadStoreRepo {
  Future<Map<String, dynamic>> insertNewActivity(
    String mode,
    String employeeID,
    String branch,
    String shop,
    String date,
    String time,
    double lat,
    double lng,
    String activityID,
    String activityDesc,
    String? images,
  );

  Future<Map<String, dynamic>> deleteActivity(
    String mode,
    String employeeID,
    String activityID,
    String date,
  );

  Future<Map<String, dynamic>> fetchHeadActTypes();

  Future<Map<String, dynamic>> fetchHeadDashboard(
    String employeeID,
    String date,
  );

  Future<Map<String, dynamic>> fetchHeadActs(
    String employeeID,
    String date,
  );

  Future<Map<String, dynamic>> fetchHeadActsDetails(
    String employeeID,
    String date,
    String actId,
  );
}
