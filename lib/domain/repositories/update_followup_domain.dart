abstract class UpdateFollowupRepo {
  Future<Map<String, dynamic>> fetchUpdateFUDashboard(
    String salesmanId,
    String mobilePhone,
    String prospectDate,
  );

  Future<Map<String, dynamic>> saveFollowup(
    String salesmanId,
    String mobilePhone,
    String prospectDate,
    int line,
    String fuDate,
    String fuResult,
    String fuMemo,
    String nextFUDate,
  );
}
