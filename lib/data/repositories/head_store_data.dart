import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:sip_sales_clean/core/constant/api.dart';
import 'package:sip_sales_clean/data/models/act_types.dart';
import 'package:sip_sales_clean/data/models/coordinator_dashboard.dart';
import 'package:sip_sales_clean/data/models/head_store.dart';
import 'package:sip_sales_clean/data/models/result_message.dart';
import 'package:sip_sales_clean/domain/repositories/head_store_domain.dart';

class HeadStoreDataImp implements HeadStoreRepo {
  @override
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
  ) async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.insertNewHeadActsEndpoint,
    );

    Map body = {
      "Mode": mode,
      "Branch": branch,
      "Shop": shop,
      "CurrentDate": date,
      "CurrentTime": time,
      "Lat": lat,
      "Lng": lng,
      "Pic1": img,
      "EmployeeID": employeeId,
      "Lokasi": locationName,
      "Topic": description,
      "peserta": numberOfParticipants,
      "shopManager": headStore,
      "salesCounter": salesCounter,
      "salesman": salesman,
      "others": others,
    };
    log('Body: $body');

    final response = await http
        .post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 60));
    log('Response: $response');

    if (response.statusCode <= 200) {
      log('Response: ${response.statusCode}');
      final res = jsonDecode(response.body);
      log("${res['msg']}, ${res['code']}");
      if (res['msg'] == 'Sukses' && res['code'] == '100') {
        log('Fetch succeed');
        return {
          'status': 'success',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => ResultMessageModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Fail');
        return {
          'status': 'fail',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => ResultMessageModel.fromJson(e))
              .toList(),
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([]).map((e) => ResultMessageModel.fromJson(e)).toList(),
      };
    }
  }

  @override
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
  ) async {
    return {};
  }

  @override
  Future<Map<String, dynamic>> insertNewRecruitmentActivity(
    String mode,
    String branch,
    double lat,
    double lng,
    String media,
    String posisi,
    String pic1,
    String employeeID,
  ) async {
    return {};
  }

  @override
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
  ) async {
    return {};
  }

  @override
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
  ) async {
    return {};
  }

  @override
  Future<Map<String, dynamic>> deleteActivity(
    String apiEndpoint,
    String mode,
    String branch,
    String shop,
    String date,
  ) async {
    Uri uri = Uri.https(APIConstants.baseUrl, apiEndpoint);

    Map body = {
      "Mode": mode,
      "Branch": branch,
      "Shop": shop,
      "CurrentDate": date,
    };

    final response = await http
        .post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 60));
    log('Response: $response');

    if (response.statusCode <= 200) {
      log('Response: ${response.statusCode}');
      final res = jsonDecode(response.body);
      log("${res['msg']}, ${res['code']}");
      if (res['msg'] == 'Sukses' && res['code'] == '100') {
        log('Fetch succeed');
        return {
          'status': 'success',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => ResultMessageModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Fail');
        return {
          'status': 'fail',
          'code': res['code'],
          'data': ([]).map((e) => ResultMessageModel.fromJson(e)).toList(),
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([]).map((e) => ResultMessageModel.fromJson(e)).toList(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchHeadActTypes() async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.headActTypesEndpoint,
    );

    final response = await http
        .post(uri, headers: {"Content-Type": "application/json"})
        .timeout(const Duration(seconds: 60));
    log('Fetch Head Act Types Response: $response');

    if (response.statusCode <= 200) {
      log('Response: ${response.statusCode}');
      final res = jsonDecode(response.body);
      log("${res['msg']}, ${res['code']}");
      if (res['msg'] == 'Sukses' && res['code'] == '100') {
        log('Success, head act types fetched');
        log('Data Head Act Types: ${(res['data'] as List).length}');
        final finalRes = (res['data'] as List)
            .map((e) => HeadActTypesModel.fromJson(e))
            .toList();
        for (var type in finalRes) {
          log('${type.activityID} - ${type.activityName}');
        }
        return {
          'status': 'success',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => HeadActTypesModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Fail');
        return {
          'status': 'fail',
          'code': res['code'],
          'data': ([]).map((e) => HeadActTypesModel.fromJson(e)).toList(),
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([]).map((e) => HeadActTypesModel.fromJson(e)).toList(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchHeadDashboard(
    String employeeID,
    String date,
  ) async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.headDashboardEndpoint,
    );

    Map body = {
      "EmployeeID": employeeID,
      "EndDate": date,
    };
    log('Body: $body');

    final response = await http
        .post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 120));
    log('Response: $response');

    if (response.statusCode <= 200) {
      log('Response: ${response.statusCode}');
      final res = jsonDecode(response.body);
      log("${res['msg']}, ${res['code']}");
      if ((res['msg'] == 'Sukses' || res['msg'] == 'No Data') &&
          res['code'] == '100') {
        log('Fetch succeed');
        if (res['msg'] == 'No Data') {
          return {
            'status': 'no data',
            'code': res['code'],
            'data': [],
          };
        }

        return {
          'status': 'success',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => CoordinatorDashboardModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Fail');
        return {
          'status': 'fail',
          'code': res['code'],
          'data': ([])
              .map((e) => CoordinatorDashboardModel.fromJson(e))
              .toList(),
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([]).map((e) => CoordinatorDashboardModel.fromJson(e)).toList(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchHeadActs(
    String employeeID,
    String date,
  ) async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.headActsEndpoint,
    );

    Map body = {
      "EmployeeID": employeeID,
      "CurrentDate": date,
    };
    log('Fetch Head Acts body: $body');

    final response = await http
        .post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 60));
    log('Response: $response');

    if (response.statusCode <= 200) {
      log('Response Code: ${response.statusCode}');
      final res = jsonDecode(response.body);
      log("${res['msg']}, ${res['code']}");
      if (res['msg'] == 'Sukses' && res['code'] == '100') {
        log('Fetch succeed');
        return {
          'status': 'success',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => HeadActsModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Fail');
        return {
          'status': res['msg'],
          'code': res['code'],
          'data': ([]).map((e) => HeadActsModel.fromJson(e)).toList(),
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([]).map((e) => HeadActsModel.fromJson(e)).toList(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchHeadBriefingDetails(
    String employeeID,
    String date,
    String actId,
  ) async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.headActsDetailEndpoint,
    );

    Map body = {
      "EmployeeID": employeeID,
      "CurrentDate": date,
      "ActivityID": actId,
    };

    final response = await http
        .post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 60));
    log('Response: $response');

    if (response.statusCode <= 200) {
      log('Response: ${response.statusCode}');
      final res = jsonDecode(response.body);
      log("${res['msg']}, ${res['code']}");
      if (res['msg'] == 'Sukses' && res['code'] == '100') {
        log('Fetch succeed');
        return {
          'status': 'success',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => HeadActsDetailsModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Fail');
        return {
          'status': res['msg'],
          'code': res['code'],
          'data': ([]).map((e) => HeadActsDetailsModel.fromJson(e)).toList(),
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([]).map((e) => HeadActsDetailsModel.fromJson(e)).toList(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchHeadVisitDetails(
    String branch,
    String shop,
    String currentDate,
  ) async {
    return {};
  }

  @override
  Future<Map<String, dynamic>> fetchHeadRecruitmentDetails(
    String branch,
    String shop,
    String currentDate,
  ) async {
    return {};
  }

  @override
  Future<Map<String, dynamic>> fetchHeadInterviewDetails(
    String branch,
    String shop,
    String currentDate,
  ) async {
    return {};
  }

  @override
  Future<Map<String, dynamic>> fetchHeadReportDetails(
    String branch,
    String shop,
    String currentDate,
  ) async {
    return {};
  }

  @override
  Future<Map<String, dynamic>> fetchHeadBriefingMaster(
    String branch,
    String shop,
  ) async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.headBriefingMasterEndpoint,
    );

    Map body = {
      "Branch": branch,
      "Shop": shop,
    };

    final response = await http
        .post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 60));
    log('Response: $response');

    if (response.statusCode <= 200) {
      log('Response: ${response.statusCode}');
      final res = jsonDecode(response.body);
      log("${res['msg']}, ${res['code']}");
      if (res['msg'] == 'Sukses' && res['code'] == '100') {
        log('Briefing Master fetch succeed');
        return {
          'status': 'success',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => HeadBriefingMasterModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Briefing Master fetch failed');
        return {
          'status': res['msg'],
          'code': res['code'],
          'data': ([]).map((e) => HeadBriefingMasterModel.fromJson(e)).toList(),
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([]).map((e) => HeadBriefingMasterModel.fromJson(e)).toList(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchHeadVisitMaster(
    String branch,
    String shop,
  ) async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.headVisitMasterEndpoint,
    );

    Map body = {
      "Branch": branch,
      "Shop": shop,
    };

    final response = await http
        .post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 60));
    log('Response: $response');

    if (response.statusCode <= 200) {
      log('Response: ${response.statusCode}');
      final res = jsonDecode(response.body);
      log("${res['msg']}, ${res['code']}");
      if (res['msg'] == 'Sukses' && res['code'] == '100') {
        log('Visit Master fetch succeed');
        return {
          'status': 'success',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => HeadVisitMasterModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Visit Master fetch failed');
        return {
          'status': res['msg'],
          'code': res['code'],
          'data': ([]).map((e) => HeadVisitMasterModel.fromJson(e)).toList(),
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([]).map((e) => HeadVisitMasterModel.fromJson(e)).toList(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchHeadRecruitmentMaster(
    String branch,
    String shop,
  ) async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.headRecruitmentMasterEndpoint,
    );

    Map body = {
      "Branch": branch,
      "Shop": shop,
    };

    final response = await http
        .post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 60));
    log('Response: $response');

    if (response.statusCode <= 200) {
      log('Response: ${response.statusCode}');
      final res = jsonDecode(response.body);
      log("${res['msg']}, ${res['code']}");
      if (res['msg'] == 'Sukses' && res['code'] == '100') {
        log('Recruitment Master fetch succeed');
        return {
          'status': 'success',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => HeadRecruitmentMasterModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Recruitment Master fetch failed');
        return {
          'status': res['msg'],
          'code': res['code'],
          'data': ([])
              .map((e) => HeadRecruitmentMasterModel.fromJson(e))
              .toList(),
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([])
            .map((e) => HeadRecruitmentMasterModel.fromJson(e))
            .toList(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchHeadInterviewMaster(
    String branch,
    String shop,
  ) async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.headInterviewMasterEndpoint,
    );

    Map body = {
      "Branch": branch,
      "Shop": shop,
    };

    final response = await http
        .post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 60));
    log('Response: $response');

    if (response.statusCode <= 200) {
      log('Response: ${response.statusCode}');
      final res = jsonDecode(response.body);
      log("${res['msg']}, ${res['code']}");
      if (res['msg'] == 'Sukses' && res['code'] == '100') {
        log('Interview Master fetch succeed');
        return {
          'status': 'success',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => HeadInterviewMasterModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Interview Master fetch failed');
        return {
          'status': res['msg'],
          'code': res['code'],
          'data': ([])
              .map((e) => HeadInterviewMasterModel.fromJson(e))
              .toList(),
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([]).map((e) => HeadInterviewMasterModel.fromJson(e)).toList(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> fetchHeadReportMaster(
    String branch,
    String shop,
  ) async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.headReportMasterEndpoint,
    );

    Map body = {
      "Branch": branch,
      "Shop": shop,
    };

    final response = await http
        .post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 60));
    log('Response: $response');

    if (response.statusCode <= 200) {
      log('Response: ${response.statusCode}');
      final res = jsonDecode(response.body);
      log("${res['msg']}, ${res['code']}");
      if (res['msg'] == 'Sukses' && res['code'] == '100') {
        log('Report Master fetch succeed');
        return {
          'status': 'success',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => HeadReportMasterModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Report Master fetch failed');
        return {
          'status': res['msg'],
          'code': res['code'],
          'data': ([]).map((e) => HeadReportMasterModel.fromJson(e)).toList(),
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([]).map((e) => HeadReportMasterModel.fromJson(e)).toList(),
      };
    }
  }
}
