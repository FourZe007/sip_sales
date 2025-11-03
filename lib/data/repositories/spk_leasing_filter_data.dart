import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:sip_sales_clean/core/constant/api.dart';
import 'package:sip_sales_clean/data/models/spk_leasing.dart';
import 'package:sip_sales_clean/domain/repositories/spk_leasing_filter_domain.dart';

class SpkLeasingFilterDataImp implements SpkLeasingFilterRepo {
  @override
  Future<Map<String, dynamic>> loadGroupDealer(
    String employeeId,
  ) async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.spkLeasingFilterGroupDealerEndpoint,
    );

    Map body = {"EmployeeID": employeeId};

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
              .map((e) => SpkGrouDealerModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Fail');
        return {
          'status': 'fail',
          'code': res['code'],
          'data': ([]).map((e) => SpkGrouDealerModel.fromJson(e)).toList(),
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([]).map((e) => SpkGrouDealerModel.fromJson(e)).toList(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> loadDealer(
    String employeeId,
    String groupName,
  ) async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.spkLeasingFilterDealerEndpoint,
    );

    Map body = {
      "EmployeeID": employeeId,
      "GroupName": groupName,
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
              .map((e) => SpkDealerModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Fail');
        return {
          'status': 'fail',
          'code': res['code'],
          'data': ([]).map((e) => SpkDealerModel.fromJson(e)).toList(),
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([]).map((e) => SpkDealerModel.fromJson(e)).toList(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> loadLeasing() async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.spkLeasingFilterLeasingEndpoint,
    );

    final response = await http
        .post(
          uri,
          headers: {"Content-Type": "application/json"},
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
              .map((e) => SpkLeasingModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Fail');
        return {
          'status': 'fail',
          'code': res['code'],
          'data': ([]).map((e) => SpkLeasingModel.fromJson(e)).toList(),
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([]).map((e) => SpkLeasingModel.fromJson(e)).toList(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> loadCategory() async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.spkLeasingFilterCategoryEndpoint,
    );

    final response = await http
        .post(
          uri,
          headers: {"Content-Type": "application/json"},
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
              .map((e) => SpkCategoryModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Fail');
        return {
          'status': 'fail',
          'code': res['code'],
          'data': ([]).map((e) => SpkCategoryModel.fromJson(e)).toList(),
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([]).map((e) => SpkCategoryModel.fromJson(e)).toList(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> loadSpkLeasingData(
    String employeeId,
    String date,
    String branch,
    String category,
    String leasing,
    String dealer,
  ) async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.spkLeasingDataEndpoint,
    );

    Map body = {
      "EmployeeID": employeeId,
      // "TransDate": date,
      "TransDate": '2025-10-31',
      "BranchShop": branch,
      "Category": category,
      "LeasingID": leasing,
      "JenisDealer": dealer,
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
      if ((res['msg'] == 'Sukses' || res['msg'] == 'No Data') &&
          res['code'] == '100') {
        log('loadSpkLeasingData Fetch succeed');
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
              .map((e) => SpkDataModel.fromJson(e))
              .toList()[0],
        };
      } else {
        log('loadSpkLeasingData Fail');
        return {
          'status': 'fail',
          'code': res['code'],
          'data': [],
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': [],
      };
    }
  }
}
