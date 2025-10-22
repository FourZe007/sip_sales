import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:sip_sales_clean/core/constant/api.dart';
import 'package:sip_sales_clean/data/models/update_fu_dashboard.dart';
import 'package:sip_sales_clean/domain/repositories/update_followup_domain.dart';

class UpdateFollowupDataImp implements UpdateFollowupRepo {
  @override
  Future<Map<String, dynamic>> fetchUpdateFUDashboard(
    String salesmanId,
    String mobilePhone,
    String prospectDate,
  ) async {
    // Simulate a network call
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.fetchFuDetailEndpoint,
    );

    Map body = {
      "EmployeeID": salesmanId,
      "MobilePhone": mobilePhone,
      "ProspectDate": prospectDate,
    };
    log('Map Body: $body');

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    log('Response: $response');

    if (response.statusCode <= 200) {
      log('Response: ${response.statusCode}');
      final res = jsonDecode(response.body);
      log("${res['msg']}, ${res['code']}");
      if (res['msg'] == 'Sukses' && res['code'] == '100') {
        log('Success');
        return {
          'status': 'success',
          'code': res['code'],
          'data': (res['data'] as List)
              .map((e) => UpdateFollowUpDashboardModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Fail');
        return {
          'status': 'fail',
          'code': res['code'],
          'data': ([])
              .map((e) => UpdateFollowUpDashboardModel.fromJson(e))
              .toList(),
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([])
            .map((e) => UpdateFollowUpDashboardModel.fromJson(e))
            .toList(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> saveFollowup(
    String salesmanId,
    String mobilePhone,
    String prospectDate,
    int line,
    String fuDate,
    String fuResult,
    String fuMemo,
    String nextFUDate,
  ) async {
    // Simulate a network call
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.fetchFuDetailEndpoint,
    );

    Map body = {
      "EmployeeID": salesmanId,
      "MobilePhone": mobilePhone,
      "ProspectDate": prospectDate,
      "Line": line,
      "FUDate": fuDate,
      "FUResult": fuResult,
      "FUMemo": fuMemo,
      "NextFUDate": nextFUDate,
    };
    log('Map Body: $body');

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    log('Response: $response');

    if (response.statusCode <= 200) {
      var jsonResult = jsonDecode(response.body);
      if (jsonResult['code'] == '100' && jsonResult['msg'] == 'Sukses') {
        if (jsonResult['data'] != null &&
            jsonResult['data'][0]['resultMessage'].toString().toLowerCase() ==
                'sukses') {
          log('Success');
          return {
            'status': 'sukses',
            'data': 'success',
          };
        } else {
          log('Failed');
          return {
            'status': 'gagal',
            'data': jsonResult['data'][0]['resultMessage']
                .toString()
                .toLowerCase(),
          };
        }
      } else {
        log('Failed');
        return {
          'status': 'gagal',
          'data': 'Error ${jsonResult['code']}, ${jsonResult['msg']}',
        };
      }
    } else {
      log('Failed');
      return {
        'status': 'gagal',
        'data': 'Status code ${response.statusCode}, coba lagi.',
      };
    }
  }
}
