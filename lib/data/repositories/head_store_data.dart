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
  ) async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.insertNewHeadActsEndpoint,
    );

    Map body = {
      "Mode": mode,
      "EmployeeID": employeeID,
      "CurrentDate": date,
      "CurrentTime": time,
      "Branch": branch,
      "Shop": shop,
      "Lat": lat,
      "Lng": lng,
      "ActivityID": activityID,
      "ActivityDescription": activityDesc,
      "Pic1": images,
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
  Future<Map<String, dynamic>> deleteActivity(
    String mode,
    String employeeId,
    String date,
    String activityId,
  ) async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.insertNewHeadActsEndpoint,
    );

    Map body = {
      "Mode": mode,
      "EmployeeID": employeeId,
      "CurrentDate": date,
      "CurrentTime": '',
      "Branch": '',
      "Shop": '',
      "Lat": 0,
      "Lng": 0,
      "ActivityID": activityId,
      "ActivityDescription": '',
      "Pic1": '',
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
  Future<Map<String, dynamic>> fetchHeadActsDetails(
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
        log('Fetch succeed');
        return {
          'status': 'success',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => HeadBriefingMasterModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Fail');
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
        log('Fetch succeed');
        return {
          'status': 'success',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => HeadVisitMasterModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Fail');
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
        log('Fetch succeed');
        return {
          'status': 'success',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => HeadRecruitmentMasterModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Fail');
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
        log('Fetch succeed');
        return {
          'status': 'success',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => HeadInterviewMasterModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Fail');
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
        log('Fetch succeed');
        return {
          'status': 'success',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => HeadReportMasterModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Fail');
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
