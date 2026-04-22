import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:sip_sales_clean/core/constant/api.dart';
import 'package:sip_sales_clean/data/models/salesman.dart';
import 'package:sip_sales_clean/domain/repositories/salesman_domain.dart';

class SalesmanDataImp implements SalesmanRepo {
  @override
  Future<Map<String, dynamic>> loadAttendance(
    String salesmanId,
    String startDate,
    String endDate,
  ) async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.salesmanAttendanceEndpoint,
    );
    log('loadAttendance Uri: $uri');

    Map body = {
      "EmployeeID": salesmanId,
      "BeginDate": startDate,
      "EndDate": endDate,
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
      log("${res['Msg']}, ${res['Code']}");
      final msg = res['Msg'].toString().toLowerCase();

      if (res['Code'] == '100') {
        log('loadAttendance Fetched');
        return {
          'status': msg == 'sukses' ? 'success' : msg,
          'code': res['Code'],
          'data': (res['Data'] as List)
              .map((e) => SalesmanAttendanceModel.fromJson(e))
              .where((e) => e.checkIn.isNotEmpty)
              .toList(),
        };
      } else {
        log('loadAttendance failed to fetch');
        return {
          'status': msg,
          'code': res['Code'],
          'data': <SalesmanAttendanceModel>[],
        };
      }
    } else {
      log('loadAttendance Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([]).map((e) => SalesmanAttendanceModel.fromJson(e)).toList(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> loadDashboard(
    String salesmanId,
    String endDate,
  ) async {
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.salesmanDashboardEndpoint,
    );

    Map body = {
      "EmployeeID": salesmanId,
      "EndDate": endDate,
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
              .map((e) => SalesmanDashboardModel.fromJson(e))
              .toList(),
        };
      } else {
        log('Fail');
        return {
          'status': 'fail',
          'code': res['code'],
          'data': ([]).map((e) => SalesmanDashboardModel.fromJson(e)).toList(),
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([]).map((e) => SalesmanDashboardModel.fromJson(e)).toList(),
      };
    }
  }
}
