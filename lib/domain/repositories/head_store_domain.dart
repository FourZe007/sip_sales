import 'package:sip_sales_clean/data/models/head_store.dart';

abstract class HeadStoreRepo {
  Future<Map<String, dynamic>> insertNewBriefingActivity(
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

  Future<Map<String, dynamic>> insertNewVisitActivity(
    String mode,
    String branch,
    String shop,
    String date,
    String time,
    double lat,
    double lng,
    String activityType,
    String location,
    int salesman,
    String unitDisplay,
    int database,
    int hotProspek,
    int deal,
    String unitTestRide,
    int participantsTestRide,
    String pic1,
    String employeeId,
  );

  Future<Map<String, dynamic>> insertNewRecruitmentActivity(
    String mode,
    String branch,
    double lat,
    double lng,
    String media,
    String posisi,
    String pic1,
    String employeeID,
  );

  Future<Map<String, dynamic>> insertNewInterviewActivity(
    String mode,
    String branch,
    String shop,
    String currentDate,
    String currentTime,
    double lat,
    double lng,
    int dipanggil,
    int datang,
    int diterima,
    String pic1,
    String employeeID,
    List<HeadMediaMasterModel> listMedia,
  );

  Future<Map<String, dynamic>> insertNewReportActivity(
    String mode,
    String branch,
    String shop,
    String date,
    String time,
    double lat,
    double lng,
    String img,
    String employeeId,
    List<HeadStuCategoriesMasterModel> categoryList,
    List<HeadPaymentMasterModel> paymentList,
    List<HeadLeasingMasterModel> leasingList,
    List<HeadEmployeeMasterModel> employeeList,
  );

  Future<Map<String, dynamic>> deleteActivity(
    String apiEndpoint,
    String mode,
    String branch,
    String shop,
    String date,
  );

  Future<Map<String, dynamic>> fetchHeadActTypes();

  Future<Map<String, dynamic>> fetchHeadDashboard(
    String employeeID,
    String date,
  );

  Future<Map<String, dynamic>> fetchHeadActs(
    String employeeId,
    String currentDate,
  );

  // ~:Split into 5 types of activities:~
  // Future<Map<String, dynamic>> fetchHeadActsDetails(
  //   String employeeID,
  //   String date,
  //   String actId,
  // );
  Future<Map<String, dynamic>> fetchHeadBriefingDetails(
    String branch,
    String shop,
    String currentDate,
  );

  Future<Map<String, dynamic>> fetchHeadVisitDetails(
    String branch,
    String shop,
    String currentDate,
  );

  Future<Map<String, dynamic>> fetchHeadRecruitmentDetails(
    String branch,
    String shop,
    String currentDate,
  );

  Future<Map<String, dynamic>> fetchHeadInterviewDetails(
    String branch,
    String shop,
    String currentDate,
  );

  Future<Map<String, dynamic>> fetchHeadReportDetails(
    String branch,
    String shop,
    String currentDate,
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
