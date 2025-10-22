import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:sip_sales_clean/core/constant/api.dart';
import 'package:sip_sales_clean/data/models/coordinator_dashboard.dart';
import 'package:sip_sales_clean/domain/repositories/dashboard_domain.dart';

class DashboardDataImp implements DashboardRepo {
  @override
  Future<Map<String, dynamic>> fetchCoordinatorDashboard(
    String employeeId,
    String date,
  ) async {
    // Simulate a network call
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.coordinatorDashboardEndpoint,
    );

    Map body = {
      "EmployeeID": employeeId,
      "EndDate": date,
    };
    log('Map Body: $body');

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    log('Response: $response');

    // return LoginModel.fromJson(jsonDecode(res.body));

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
}
