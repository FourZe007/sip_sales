abstract class HeadStoreRepo {
  Future<Map<String, dynamic>> insertNewActivity(
    // "Mode":"1",
    // "Branch":"02",
    // "Shop":"01",
    // "CurrentDate":"2025-11-12",
    // "CurrentTime":"08:24",
    // "Lat":0,
    // "Lng":0,
    // "Pic1":"",
    // "EmployeeID":"",
    // "Lokasi":"DEALER",
    // "Topic":"PENJUALAN MINGGU KE 2",
    // "peserta": 31,
    // "shopManager": 1,
    // "salesCounter": 2,
    // "salesman": 27,
    // "others": 0
    String mode,
    String branch,
    String shop,
    String date,
    String time,
    double lat,
    double lng,
    String img,
    String employeeId,
    String locationName,
    String description,
    int numberOfParticipants,
    int headStore,
    int salesCounter,
    int salesman,
    int others,
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

  Future<Map<String, dynamic>> fetchHeadBriefingMaster(
    String branch,
    String shop,
  );

  Future<Map<String, dynamic>> fetchHeadVisitMaster(
    String branch,
    String shop,
  );

  Future<Map<String, dynamic>> fetchHeadRecruitmentMaster(
    String branch,
    String shop,
  );

  Future<Map<String, dynamic>> fetchHeadInterviewMaster(
    String branch,
    String shop,
  );

  Future<Map<String, dynamic>> fetchHeadReportMaster(
    String branch,
    String shop,
  );
}
