// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:sip_sales/global/model.dart';
import 'package:http/http.dart' as http;

class GlobalAPI {
  static Future<List<ModelUser>> fetchUserAccount(
    String id,
    String pass,
  ) async {
    var url =
        Uri.https('wsip.yamaha-jatim.co.id:2448', '/api/Login/LoginSalesman');

    Map mapUserAccount = {
      "EmployeeID": id,
      "DecryptedPassword": pass,
    };

    try {
      final response =
          await http.post(url, body: jsonEncode(mapUserAccount), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      List<ModelUser> list = [];

      if (response.statusCode <= 200) {
        var jsonUserAccount = jsonDecode(response.body);
        if (jsonUserAccount['Code'] == '100' ||
            jsonUserAccount['Msg'] == 'Sukses') {
          list = (jsonUserAccount['Data'] as List)
              .map<ModelUser>((data) => ModelUser.fromJson(data))
              .toList();

          return list;
        } else {
          list = (jsonUserAccount['Data'] as List)
              .map<ModelUser>((data) => ModelUser.fromJson(data))
              .toList();

          return list;
        }
      }

      return list;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<List<ModelAttendanceHistory>> fetchAttendanceHistory(
    String employeeID,
    String beginDate,
    String endDate,
  ) async {
    var url = Uri.https(
        'wsip.yamaha-jatim.co.id:2448', '/api/SIPSales/AttendanceHistory');

    Map mapAttendanceHistory = {
      "EmployeeID": employeeID,
      "BeginDate": beginDate,
      "EndDate": endDate,
    };

    final response =
        await http.post(url, body: jsonEncode(mapAttendanceHistory), headers: {
      'Content-Type': 'application/json',
    }).timeout(const Duration(seconds: 60));

    List<ModelAttendanceHistory> list = [];

    if (response.statusCode <= 200) {
      var jsonAttendanceHistory = jsonDecode(response.body);
      if (jsonAttendanceHistory['Code'] == '100' ||
          jsonAttendanceHistory['Msg'] == 'Sukses') {
        List<ModelAttendanceHistory> list =
            (jsonAttendanceHistory['Data'] as List)
                .map<ModelAttendanceHistory>(
                    (data) => ModelAttendanceHistory.fromJson(data))
                .toList();

        return list;
      } else {
        return list;
      }
    }

    return list;
    //   final response = await http
    //       .post(url, body: jsonEncode(mapAttendanceHistory), headers: {
    //     'Content-Type': 'application/json',
    //   }).timeout(const Duration(seconds: 60));
    //
    //   print('Response');
    //   print(response.body);
    //   List<ModelAttendanceHistory> list = [];
    //
    //   if (response.statusCode <= 200) {
    //     var jsonAttendanceHistory = jsonDecode(response.body);
    //     if (jsonAttendanceHistory['Code'] == '100' ||
    //         jsonAttendanceHistory['Msg'] == 'Sukses') {
    //       List<ModelAttendanceHistory> list =
    //           (jsonAttendanceHistory['Data'] as List)
    //               .map<ModelAttendanceHistory>(
    //                   (data) => ModelAttendanceHistory.fromJson(data))
    //               .toList();
    //
    //       return list;
    //     } else {
    //       List<ModelAttendanceHistory> list =
    //           (jsonAttendanceHistory['Data'] as List)
    //               .map<ModelAttendanceHistory>(
    //                   (data) => ModelAttendanceHistory.fromJson(data))
    //               .toList();
    //
    //       return list;
    //     }
    //   }
    //
    //   return list;
    // } catch (e) {
    //   print(e.toString());
    //   return throw e;
    // }
  }

  static Future<List<ModelResultMessage>> fetchModifyAttendance(
    String mode,
    String id,
    String branch,
    String shop,
    String locationID,
    String date, // date
    String checkIn, // time
    String checkOut, // time
  ) async {
    var url = Uri.https(
        'wsip.yamaha-jatim.co.id:2448', '/api/SIPSales/InsertAttendance');

    // Check in -> ID, Date and CheckIn
    // Check out -> ID, Date and CheckOut
    Map mapModifyAttendance = {
      "Mode": mode,
      "Data": {
        "EmployeeID": id, // mandatory
        "Branch": branch != '' ? branch : '',
        "Shop": shop != '' ? shop : '',
        "LocationID": locationID,
        "Date_": date, // mandatory
        "CheckIn": checkIn != '' ? checkIn : '', // mandatory for check in
        "CheckOut": checkOut != '' ? checkOut : '', // mandatory for check out
      }
    };

    try {
      final response =
          await http.post(url, body: jsonEncode(mapModifyAttendance), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      List<ModelResultMessage> list = [];

      if (response.statusCode <= 200) {
        var jsonUserAccount = jsonDecode(response.body);
        if (jsonUserAccount['Code'] == '100' ||
            jsonUserAccount['Msg'] == 'Sukses') {
          List<ModelResultMessage> list = (jsonUserAccount['Data'] as List)
              .map<ModelResultMessage>(
                  (data) => ModelResultMessage.fromJson(data))
              .toList();

          return list;
        } else {
          List<ModelResultMessage> list = (jsonUserAccount['Data'] as List)
              .map<ModelResultMessage>(
                  (data) => ModelResultMessage.fromJson(data))
              .toList();

          return list;
        }
      }

      return list;
    } catch (e) {
      return throw e;
    }
  }

  static Future<ModelResultMessage> fetchSendMessage(
    String phoneNumber,
    String message,
    String deviceId,
    String messageType,
  ) async {
    var url = Uri.https('haryanto-agus-api.kirimwa.id', '/v1/messages');

    Map mapOTP = {
      "phone_number": phoneNumber,
      "message": message,
      "device_id": deviceId,
      "message_type": messageType,
    };

    ModelResultMessage mapSendMessage = ModelResultMessage(resultMessage: '');

    try {
      final response = await http.post(url, body: jsonEncode(mapOTP), headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'PostmanRuntime/7.35.0',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
        'Authorization':
            'Bearer Tb_3yl}VYq78qB^/NVWy0OXqgwPj0rTMhrU50qfG^@58~Hbt-enterprise',
      }).timeout(const Duration(seconds: 60));

      if (response.statusCode <= 201) {
        var jsonSendOTP = jsonDecode(response.body);
        if (jsonSendOTP['status'] == 'pending' ||
            jsonSendOTP['message'] ==
                'Message is pending and waiting to be processed.') {
          mapSendMessage =
              ModelResultMessage(resultMessage: jsonSendOTP['status']);

          return mapSendMessage;
        } else {
          mapSendMessage =
              ModelResultMessage(resultMessage: jsonSendOTP['status']);

          return mapSendMessage;
        }
      }

      return mapSendMessage;
    } catch (e) {
      return throw e;
    }
  }

  static Future<List<ModelResultMessage2>> fetchActivityTimestamp(
    String mode,
    String employeeID,
    String date,
    List<ModelCoordinate> coordinateList,
  ) async {
    var url = Uri.https('wsip.yamaha-jatim.co.id:2448',
        '/api/SIPSales/InsertEmployeeActivityTimeStamp');

    Map mapActivityTimestamp = {
      "Mode": mode,
      "Detail": coordinateList.map((list) {
        return {
          "EmployeeID": employeeID,
          "CurrentDate": date,
          "CurrentTime": list.time,
          "Lat": list.latitude,
          "Lng": list.longitude,
        };
      }).toList()
    };

    List<ModelResultMessage2> resultMessageList = [];

    try {
      final response = await http
          .post(url, body: jsonEncode(mapActivityTimestamp), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      if (response.statusCode <= 200) {
        var jsonActivityTimestamp = jsonDecode(response.body);
        if (jsonActivityTimestamp['code'] == '100' ||
            jsonActivityTimestamp['msg'] == 'Sukses') {
          resultMessageList = (jsonActivityTimestamp['data'] as List)
              .map<ModelResultMessage2>(
                  (list) => ModelResultMessage2.fromJson(list))
              .toList();

          return resultMessageList;
        } else {
          return [];
        }
      } else {}

      return resultMessageList;
    } catch (e) {
      return resultMessageList;
    }
  }

  static Future<List<ModelActivityRoute>> fetchActivityRoute(
    String employeeID,
    String date,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/EmployeeActivityRoute',
    );

    Map mapActivityRoute = {
      "EmployeeID": employeeID,
      "CurrentDate": date,
    };

    List<ModelActivityRoute> activityRouteList = [];

    try {
      final response =
          await http.post(url, body: jsonEncode(mapActivityRoute), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      if (response.statusCode <= 200) {
        var jsonActivityRoute = jsonDecode(response.body);
        if (jsonActivityRoute['code'] == '100' &&
            jsonActivityRoute['msg'] == 'Sukses') {
          activityRouteList = (jsonActivityRoute['data'] as List)
              .map<ModelActivityRoute>(
                  (list) => ModelActivityRoute.fromJson(list))
              .toList();

          return activityRouteList;
        } else {
          return activityRouteList;
        }
      } else {}
      return activityRouteList;
    } catch (e) {
      print('Error: ${e.toString()}');
      return activityRouteList;
    }
  }

  static Future<List<ModelActivities>> fetchSalesActivityTypes() async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/MEmployeeActivity',
    );

    List<ModelActivities> salesActivityTypesList = [];

    try {
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      if (response.statusCode <= 200) {
        var jsonActivitytypes = jsonDecode(response.body);
        if (jsonActivitytypes['code'] == '100' &&
            jsonActivitytypes['msg'] == 'Sukses') {
          salesActivityTypesList = (jsonActivitytypes['data'] as List)
              .map<ModelActivities>((list) => ModelActivities.fromJson(list))
              .toList();

          return salesActivityTypesList;
        } else {
          return salesActivityTypesList;
        }
      } else {}
      return salesActivityTypesList;
    } catch (e) {
      print(e.toString());
      return salesActivityTypesList;
    }
  }

  // ~:NEW:~:
  static Future<List<ModelActivities>> fetchManagerActivityTypes() async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/MEmployeeActivitySM',
    );

    List<ModelActivities> managerActivityTypesList = [];

    try {
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      if (response.statusCode <= 200) {
        var jsonActivitytypes = jsonDecode(response.body);
        if (jsonActivitytypes['code'] == '100' &&
            jsonActivitytypes['msg'] == 'Sukses') {
          managerActivityTypesList = (jsonActivitytypes['data'] as List)
              .map<ModelActivities>((list) => ModelActivities.fromJson(list))
              .toList();

          return managerActivityTypesList;
        } else {
          return managerActivityTypesList;
        }
      } else {}
      return managerActivityTypesList;
    } catch (e) {
      print(e.toString());
      return managerActivityTypesList;
    }
  }
  // ~:NEW:~

  static Future<List<ModelResultMessage2>> fetchNewSalesActivity(
    String employeeID,
    String date,
    String time,
    double lat,
    double lng,
    String activityID,
    String activityDesc,
    String name,
    String number,
    List<String?> images,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/InsertEmployeeActivity',
    );

    Map mapNewSalesActivity = {
      "EmployeeID": employeeID,
      "CurrentDate": date,
      "CurrentTime": time,
      "Lat": lat,
      "Lng": lng,
      "ActivityID": activityID,
      "ActivityDescription": activityDesc,
      "ContactName": name,
      "ContactPHoneNo": number,
      "Pic1": images.length == 1 ? images[0] : '',
      "Pic2": '',
      "Pic3": '',
      "Pic4": '',
      "Pic5": '',
    };

    List<ModelResultMessage2> activityTypesList = [];

    try {
      final response =
          await http.post(url, body: jsonEncode(mapNewSalesActivity), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      if (response.statusCode <= 200) {
        var jsonActivitytypes = jsonDecode(response.body);
        if (jsonActivitytypes['code'] == '100' &&
            jsonActivitytypes['msg'] == 'Sukses') {
          activityTypesList = (jsonActivitytypes['data'] as List)
              .map<ModelResultMessage2>(
                  (list) => ModelResultMessage2.fromJson(list))
              .toList();

          return activityTypesList;
        } else {
          return activityTypesList;
        }
      } else {}
      return activityTypesList;
    } catch (e) {
      print(e.toString());
      return activityTypesList;
    }
  }

  static Future<List<ModelResultMessage2>> fetchNewManagerActivity(
    String employeeID,
    String date,
    String time,
    String branch,
    String shop,
    double lat,
    double lng,
    String activityID,
    String activityDesc,
    List<String?> images,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/InsertEmployeeActivitySM',
    );

    Map mapNewManagerActivity = {
      "EmployeeID": employeeID,
      "CurrentDate": date,
      "CurrentTime": time,
      "Branch": "01",
      "Shop": "01",
      "Lat": lat,
      "Lng": lng,
      "ActivityID": activityID,
      "ActivityDescription": activityDesc,
      "Pic1": images.length == 1 ? images[0] : '',
    };

    List<ModelResultMessage2> activityTypesList = [];

    try {
      final response = await http
          .post(url, body: jsonEncode(mapNewManagerActivity), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      if (response.statusCode <= 200) {
        var jsonActivitytypes = jsonDecode(response.body);
        if (jsonActivitytypes['code'] == '100' &&
            jsonActivitytypes['msg'] == 'Sukses') {
          activityTypesList = (jsonActivitytypes['data'] as List)
              .map<ModelResultMessage2>(
                  (list) => ModelResultMessage2.fromJson(list))
              .toList();

          return activityTypesList;
        } else {
          return activityTypesList;
        }
      } else {}
      return activityTypesList;
    } catch (e) {
      print(e.toString());
      return activityTypesList;
    }
  }
}
