class APIConstants {
  static const String baseUrl = 'wsip.yamaha-jatim.co.id:2448';

  static const String loginEndpoint = '/api/Login/LoginSalesman';
  static const String forgotPasswordEndpoint = '/api/SIPSales/ChangePassword';
  static const String resetPasswordEndpoint =
      '/api/SIPSales/RequestResetPassword';
  static const String requestIdEndpoint = '/api/SIPSales/RequestEmployeeID';
  static const String headActTypesEndpoint =
      '/api/SIPSales/MEmployeeActivitySM';
  static const String headActsEndpoint =
      '/DealerActivity/DealerActivity/BrowseBySM';
  // Head Store Old Header API: '/api/SIPSales/EmployeeActivitySMHeader';
  static const String headActsDetailEndpoint =
      '/api/SIPSales/EmployeeActivitySMDetail';
  static const String spkLeasingDataEndpoint = '/DBapi/DBSPKLeasing';
  static const String spkLeasingFilterGroupDealerEndpoint =
      '/DBapi/DBSPKLeasing/MGroupDealer';
  static const String spkLeasingFilterDealerEndpoint =
      '/DBapi/DBSPKLeasing/MBranchShop';
  static const String spkLeasingFilterLeasingEndpoint =
      '/DBapi/DBSPKLeasing/MLeasing';
  static const String spkLeasingFilterCategoryEndpoint =
      '/DBapi/DBSPKLeasing/MMotorCategory';
  static const String insertProfilePictureEndpoint =
      '/api/SIPSales/UploadPhoto';
  static const String salesmanAttendanceEndpoint =
      '/api/SIPSales/AttendanceHistory';
  static const String radiusCheckerEndpoint = '/api/SIPSales/CheckRadius';
  static const String dailyAttendanceEndpoint =
      '/api/SIPSales/InsertAttendance';
  static const String eventAttendanceEndpoint =
      '/api/SIPSales/InsertAttendanceEvent';
  static const String attendanceDetailsEndpoint =
      '/api/SIPSales/AttendanceHistory';
  static const String salesmanDashboardEndpoint = '/DBSales/DBSales01';
  static const String fetchFuEndpoint = '/DBSales/DBSales02';
  static const String fetchFuDetailEndpoint =
      '/DBSales/DBSales02/ProspectDetail';
  static const String saveFuDetailEndpoint = '/DBSales/DBSales02/ModifyFU';
  static const String fetchFuDealEndpoint = '/DBSales/DBSales03';
  static const String coordinatorDashboardEndpoint = '/DBSales/DBSales04';
  static const String headDashboardEndpoint = '/DBSales/DBSales05';
  static const String insertNewHeadActsEndpoint =
      '/api/SIPSales/InsertEmployeeActivitySM';
  static const String fetchSalesProfileEndpoint =
      '/api/BrowseSubDealer/SubDealerSalesman';
  static const String salesAndReportEndpoint = '/api/ModifySubDealer';

  // ~:Head Store Input Default Values:~
  static const String headBriefingMasterEndpoint =
      '/DealerActivity/DealerActivity01/Master';
  static const String headVisitMasterEndpoint =
      '/DealerActivity/DealerActivity02/Master';
  static const String headRecruitmentMasterEndpoint =
      '/DealerActivity/DealerActivity03/Master_1';
  static const String headReportMasterEndpoint =
      '/DealerActivity/DealerActivity03/Master_2';
  static const String headInterviewMasterEndpoint =
      '/DealerActivity/DealerActivity04/Master';
}
