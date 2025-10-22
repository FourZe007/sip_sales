import 'dart:convert';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:sip_sales_clean/core/constant/api.dart';
import 'package:sip_sales_clean/data/models/employee.dart';
import 'package:sip_sales_clean/data/models/result_message_2.dart';
import 'package:sip_sales_clean/domain/repositories/attendance_domain.dart';

class AttendanceRepoImp implements AttendanceRepo {
  @override
  Future<Map<String, dynamic>> dailyAttendance(
    EmployeeModel employee,
    String date,
    String time,
    Position position,
  ) async {
    // Simulate a network call
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.dailyAttendanceEndpoint,
    );

    Map body = {
      "Mode": "1",
      "Data": {
        "EmployeeID": employee.employeeID,
        "Branch": employee.branch,
        "Shop": employee.shop,
        "LocationID": employee.locationID,
        "Date_": date,
        "CheckIn": time,
        "CheckOut": "",
        "Lat": position.latitude,
        "Lng": position.longitude,
      },
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
      log("${res['Msg']}, ${res['Code']}");
      if (res['Msg'].toLowerCase() == 'sukses' && res['Code'] == '100') {
        log('Daily Attendance Success');
        return {
          'status': 'success',
          'code': res['Code'],
          'data': (res['Data'] as List)
              .map((e) => ResultMessageModel2.fromJson(e))
              .toList()[0]
              .resultMessage,
        };
      } else {
        log('Daily Attendance Fail');
        return {
          'status': 'fail',
          'code': res['Code'],
          'data': (res['Data'] as List)
              .map((e) => ResultMessageModel2.fromJson(e))
              .toList()[0]
              .resultMessage,
        };
      }
    } else {
      log('Daily Attendance Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode.toString(),
        'data': ResultMessageModel2(
          resultMessage: '',
        ),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> eventAttendance(
    EmployeeModel employee,
    String date,
    String time,
    Position position,
    String eventDesc,
    String image,
  ) async {
    // Simulate a network call
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.eventAttendanceEndpoint,
    );

    Map body = {
      "Mode": "1",
      "Data": {
        "EmployeeID": employee.employeeID,
        "Branch": employee.branch,
        "Shop": employee.shop,
        "Date_": date,
        "CheckIn": time,
        "Lat": position.latitude,
        "Lng": position.longitude,
        "EventName": eventDesc,
        "EventPhoto": image,
      },
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
      log("${res['Msg']}, ${res['Code']}");
      if (res['Msg'].toLowerCase() == 'sukses' && res['Code'] == '100') {
        log('Event Attendance Success');
        return {
          'status': 'success',
          'code': res['Code'],
          'data': (res['Data'] as List)
              .map((e) => ResultMessageModel2.fromJson(e))
              .toList()[0]
              .resultMessage,
        };
      } else {
        log('Event Attendance Fail');
        return {
          'status': 'fail',
          'code': res['Code'],
          'data': (res['Data'] as List)
              .map((e) => ResultMessageModel2.fromJson(e))
              .toList()[0]
              .resultMessage,
        };
      }
    } else {
      log('Event Attendance Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode.toString(),
        'data': ResultMessageModel2(
          resultMessage: '',
        ),
      };
    }
  }
}
