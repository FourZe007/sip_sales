import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:sip_sales_clean/core/constant/api.dart';
import 'package:sip_sales_clean/data/models/fu_dashboard.dart';
import 'package:sip_sales_clean/domain/repositories/followup_domain.dart';

class FollowupDataImp implements FollowupRepo {
  @override
  Future<Map<String, dynamic>> fetchFollowupDashboard(
    String salesmanId,
    String date,
    bool sortByName,
  ) async {
    // Simulate a network call
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.fetchFuEndpoint,
    );

    Map body = {
      "EmployeeID": salesmanId,
      "EndDate": date,
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
        log('Success');
        return {
          'status': 'sukses',
          'code': jsonResult['code'],
          'data': (jsonResult['data'] as List)
              .map<FollowUpDashboardModel>(
                (data) => FollowUpDashboardModel.fromJson(data),
              )
              .toList(),
        };
      } else if (jsonResult['code'] == '100' &&
          jsonResult['msg'].toString().toLowerCase().replaceAll(' ', '') ==
              'nodata') {
        log('No data');
        return {
          'status': 'sukses',
          'code': jsonResult['code'],
          'data': [],
        };
      } else {
        log('Failed');
        return {
          'status': 'gagal',
          'code': jsonResult['code'],
          'data': [],
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

  @override
  Future<Map<String, dynamic>> fetchFollowupDealDashboard(
    String salesmanId,
    String date,
    bool sortByName,
  ) async {
    // Simulate a network call
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.fetchFuDealEndpoint,
    );

    Map body = {
      "EmployeeID": salesmanId,
      "EndDate": date,
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
        log('Success');
        return {
          'status': 'sukses',
          'code': jsonResult['code'],
          'data': (jsonResult['data'] as List)
              .map<FollowUpDealDashboardModel>(
                (data) => FollowUpDealDashboardModel.fromJson(data),
              )
              .toList(),
        };
      } else if (jsonResult['code'] == '100' &&
          jsonResult['msg'].toString().toLowerCase().replaceAll(' ', '') ==
              'nodata') {
        log('No data');
        return {
          'status': 'sukses',
          'code': jsonResult['code'],
          'data': [],
        };
      } else {
        log('Failed');
        return {
          'status': 'gagal',
          'code': jsonResult['code'],
          'data': [],
        };
      }
    } else {
      log('Failed');
      return {
        'status': 'gagal',
        'code': response.statusCode,
        'data': 'Status code ${response.statusCode}, coba lagi.',
      };
    }
  }
}
