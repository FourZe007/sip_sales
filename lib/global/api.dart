// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:sip_sales/global/model.dart';
import 'package:http/http.dart' as http;

class GlobalAPI {
  static Future<String> fetchIsWithinRadius(
    double latDealer,
    double lngDealer,
    double latUser,
    double lngUser,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/CheckRadius',
    );

    Map mapIsWithinRadius = {
      "LatDealer": latDealer,
      "LngDealer": lngDealer,
      "Lat": latUser,
      "Lng": lngUser,
    };

    try {
      final response =
          await http.post(url, body: jsonEncode(mapIsWithinRadius), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      String isWithinRadius = '';

      if (response.statusCode <= 200) {
        var jsonIsWithinRadius = jsonDecode(response.body);
        if (jsonIsWithinRadius['Code'] == '100' ||
            jsonIsWithinRadius['Msg'] == 'Sukses') {
          if ((jsonIsWithinRadius['Data'] as List).isNotEmpty) {
            isWithinRadius = (jsonIsWithinRadius['Data'] as List)[0]['Result'];

            return isWithinRadius;
          } else {
            return '';
          }
        } else {
          return '';
        }
      }

      return 'fail';
    } catch (e) {
      print(e.toString());
      return 'error';
    }
  }

  static Future<List<ModelUser>> fetchUserAccount(
    String id,
    String pass,
    String uuid,
    String deviceName,
  ) async {
    print('URL');
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/Login/LoginSalesman',
    );

    print('Map');
    Map mapUserAccount = {
      "EmployeeID": id,
      "DecryptedPassword": pass,
      'DeviceID': uuid,
      'DeviceName': deviceName,
    };

    print(mapUserAccount);

    print('Try and Catch');
    try {
      final response =
          await http.post(url, body: jsonEncode(mapUserAccount), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      print(response.body);

      List<ModelUser> list = [];

      print('Entering If Else Statement');
      if (response.statusCode <= 200) {
        print('Status code 200');
        var jsonUserAccount = jsonDecode(response.body);
        if (jsonUserAccount['Code'] == '100' ||
            jsonUserAccount['Msg'] == 'Sukses') {
          print('Success');
          list.addAll((jsonUserAccount['Data'] as List)
              .map<ModelUser>((data) => ModelUser.fromJson(data))
              .toList());

          return list;
        } else {
          print('Failed');
          list.addAll((jsonUserAccount['Data'] as List)
              .map<ModelUser>((data) => ModelUser.fromJson(data))
              .toList());

          return list;
        }
      }

      print('Status code 404');
      return list;
    } catch (e) {
      print('API Error: ${e.toString()}');
      return [];
    }
  }

  // ~:NEW:~:
  static Future<List<ModelResultMessage2>> fetchReqUnbindAcc(
    String employeeId,
    String excuse,
  ) async {
    print('URL');
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/RequestUnbind',
    );

    print('Map');
    Map mapUnbindRequest = {
      "EmployeeID": employeeId,
      "Reason": excuse,
    };

    print(mapUnbindRequest);

    print('Try and Catch');
    try {
      final response =
          await http.post(url, body: jsonEncode(mapUnbindRequest), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      print(response.body);

      List<ModelResultMessage2> list = [];

      print('Entering If Else Statement');
      if (response.statusCode <= 200) {
        print('Status code 200');
        var jsonChangeUserPassword = jsonDecode(response.body);
        if (jsonChangeUserPassword['code'] == '100' ||
            jsonChangeUserPassword['msg'] == 'Sukses') {
          print('Success');
          list.addAll((jsonChangeUserPassword['data'] as List)
              .map<ModelResultMessage2>(
                  (data) => ModelResultMessage2.fromJson(data))
              .toList());

          return list;
        } else {
          print('Failed');
          list.addAll((jsonChangeUserPassword['data'] as List)
              .map<ModelResultMessage2>(
                  (data) => ModelResultMessage2.fromJson(data))
              .toList());

          return list;
        }
      }

      print('Status code 404');
      return list;
    } catch (e) {
      print('API Error: ${e.toString()}');
      return [];
    }
  }

  static Future<List<ModelResultMessage2>> fetchReqEmployeeId(
    String phoneNumber,
  ) async {
    print('URL');
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/RequestEmployeeID',
    );

    print('Map');
    Map mapIdRequest = {
      "PhoneNo": phoneNumber,
    };

    print(mapIdRequest);

    print('Try and Catch');
    try {
      final response =
          await http.post(url, body: jsonEncode(mapIdRequest), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      print(response.body);

      List<ModelResultMessage2> list = [];

      if (response.statusCode <= 200) {
        print('Status code 200');
        var jsonChangeUserPassword = jsonDecode(response.body);
        if (jsonChangeUserPassword['code'] == '100' ||
            jsonChangeUserPassword['msg'] == 'Sukses') {
          print('Success');
          list.addAll((jsonChangeUserPassword['data'] as List)
              .map<ModelResultMessage2>(
                  (data) => ModelResultMessage2.fromJson(data))
              .toList());

          return list;
        } else {
          print('Failed');
          list.addAll((jsonChangeUserPassword['data'] as List)
              .map<ModelResultMessage2>(
                  (data) => ModelResultMessage2.fromJson(data))
              .toList());

          return list;
        }
      }

      print('Status code 404');
      return list;
    } catch (e) {
      print('API Error: ${e.toString()}');
      return [];
    }
  }

  static Future<List<ModelResultMessage2>> fetchResetPassword(
    String id,
  ) async {
    print('URL');
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/RequestResetPassword',
    );

    print('Map');
    Map mapPasswordReset = {
      "EmployeeID": id,
    };

    print(mapPasswordReset);

    print('Try and Catch');
    try {
      final response =
          await http.post(url, body: jsonEncode(mapPasswordReset), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      print(response.body);

      List<ModelResultMessage2> list = [];

      if (response.statusCode <= 200) {
        print('Status code 200');
        var jsonChangeUserPassword = jsonDecode(response.body);
        if (jsonChangeUserPassword['code'] == '100' ||
            jsonChangeUserPassword['msg'] == 'Sukses') {
          print('Success');
          list.addAll((jsonChangeUserPassword['data'] as List)
              .map<ModelResultMessage2>(
                  (data) => ModelResultMessage2.fromJson(data))
              .toList());

          return list;
        } else {
          print('Failed');
          list.addAll((jsonChangeUserPassword['data'] as List)
              .map<ModelResultMessage2>(
                  (data) => ModelResultMessage2.fromJson(data))
              .toList());

          return list;
        }
      }

      print('Status code 404');
      return list;
    } catch (e) {
      print('API Error: ${e.toString()}');
      return [];
    }
  }

  static Future<List<ModelResultMessage>> fetchInsertViolation(
    String employeeId,
    String violation,
  ) async {
    print('URL');
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/InsertViolation',
    );

    print('Map');
    Map mapChangeUserPassword = {
      "EmployeeID": employeeId,
      "Violation": violation,
    };

    print(mapChangeUserPassword);

    print('Try and Catch');
    try {
      final response = await http
          .post(url, body: jsonEncode(mapChangeUserPassword), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      print(response.body);

      List<ModelResultMessage> list = [];

      print('Entering If Else Statement');
      if (response.statusCode <= 200) {
        print('Status code 200');
        var jsonChangeUserPassword = jsonDecode(response.body);
        if (jsonChangeUserPassword['Code'] == '100' ||
            jsonChangeUserPassword['Msg'] == 'Sukses') {
          print('Success');
          list.addAll((jsonChangeUserPassword['Data'] as List)
              .map<ModelResultMessage>(
                  (data) => ModelResultMessage.fromJson(data))
              .toList());

          return list;
        } else {
          print('Failed');
          list.addAll((jsonChangeUserPassword['Data'] as List)
              .map<ModelResultMessage>(
                  (data) => ModelResultMessage.fromJson(data))
              .toList());

          return list;
        }
      }

      print('Status code 404');
      return list;
    } catch (e) {
      print('API Error: ${e.toString()}');
      return [];
    }
  }

  static Future<List<SalesDashboardModel>> fetchSalesDashboard(
    String employeeId,
    String branch,
    String shop,
  ) async {
    print('URL');
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/Dashboard01',
    );

    print('Map');
    Map mapChangeUserPassword = {
      'Branch': branch,
      'Shop': shop,
      'EmployeeID': employeeId,
    };

    print(mapChangeUserPassword);

    print('Try and Catch');
    try {
      final response = await http
          .post(url, body: jsonEncode(mapChangeUserPassword), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      print(response.body);

      List<SalesDashboardModel> list = [];

      print('Entering If Else Statement');
      if (response.statusCode <= 200) {
        print('Status code 200');
        var jsonChangeUserPassword = jsonDecode(response.body);
        if (jsonChangeUserPassword['code'] == '100' ||
            jsonChangeUserPassword['msg'] == 'Sukses') {
          print('Success');
          list.addAll((jsonChangeUserPassword['data'] as List)
              .map<SalesDashboardModel>(
                  (data) => SalesDashboardModel.fromJson(data))
              .toList());

          return list;
        } else {
          print('Failed');
          list.addAll((jsonChangeUserPassword['data'] as List)
              .map<SalesDashboardModel>(
                  (data) => SalesDashboardModel.fromJson(data))
              .toList());

          return list;
        }
      }

      print('Status code 404');
      return list;
    } catch (e) {
      print('API Error: ${e.toString()}');
      return [];
    }
  }

  static Future<List<ModelResultMessage2>> fetchChangeUserPassword(
    String id,
    String currentPass,
    String newPass,
  ) async {
    print('URL');
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/ChangePassword',
    );

    print('Map');
    Map mapChangeUserPassword = {
      "EmployeeID": id,
      "CurrentPassword": currentPass,
      "NewPassword": newPass,
    };

    print(mapChangeUserPassword);

    print('Try and Catch');
    try {
      final response = await http
          .post(url, body: jsonEncode(mapChangeUserPassword), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      print(response.body);

      List<ModelResultMessage2> list = [];

      print('Entering If Else Statement');
      if (response.statusCode <= 200) {
        print('Status code 200');
        var jsonChangeUserPassword = jsonDecode(response.body);
        if (jsonChangeUserPassword['code'] == '100' ||
            jsonChangeUserPassword['msg'] == 'Sukses') {
          print('Success');
          list.addAll((jsonChangeUserPassword['data'] as List)
              .map<ModelResultMessage2>(
                  (data) => ModelResultMessage2.fromJson(data))
              .toList());

          return list;
        } else {
          print('Failed');
          list.addAll((jsonChangeUserPassword['data'] as List)
              .map<ModelResultMessage2>(
                  (data) => ModelResultMessage2.fromJson(data))
              .toList());

          return list;
        }
      }

      print('Status code 404');
      return list;
    } catch (e) {
      print('API Error: ${e.toString()}');
      return [];
    }
  }

  static Future<List<ModelResultMessage>> fetchUploadImage(
    String id,
    String img,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/UploadPhoto',
    );

    print('img: $img');

    Map mapUploadImage = {
      "Mode": '1',
      "EmployeeID": id,
      'Photo': img,
    };

    print('Map upload image: $mapUploadImage');

    try {
      final response =
          await http.post(url, body: jsonEncode(mapUploadImage), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      print(response.body);

      List<ModelResultMessage> list = [];

      if (response.statusCode <= 200) {
        print('Status Code 200');
        var jsonUploadMessage = jsonDecode(response.body);
        if (jsonUploadMessage['Code'] == '100' ||
            jsonUploadMessage['Msg'] == 'Sukses') {
          print('Success');
          list.addAll((jsonUploadMessage['Data'] as List)
              .map<ModelResultMessage>(
                  (data) => ModelResultMessage.fromJson(data))
              .toList());

          return list;
        } else {
          print('Failed');
          list.addAll((jsonUploadMessage['Data'] as List)
              .map<ModelResultMessage>(
                  (data) => ModelResultMessage.fromJson(data))
              .toList());

          return list;
        }
      }

      print('Status Code 404');
      return list;
    } catch (e) {
      print('error: ${e.toString()}');
      return [];
    }
  }

  static Future<String> fetchShowImage(
    String id,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/ShowEmployeePhotoS',
    );

    Map mapShowImage = {
      "EmployeeID": id,
    };

    print(mapShowImage);

    try {
      final response =
          await http.post(url, body: jsonEncode(mapShowImage), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      print(response.body);

      if (response.statusCode <= 200) {
        var jsonShowMessage = jsonDecode(response.body);
        if (jsonShowMessage['code'] == '100' ||
            jsonShowMessage['msg'] == 'Sukses') {
          if ((jsonShowMessage['data'] as List).isNotEmpty &&
              (jsonShowMessage['data'][0]['photo'] as String).isNotEmpty) {
            return jsonShowMessage['data'][0]['photo'];
          } else {
            return 'not available';
          }
        } else {
          return 'failed';
        }
      }
      return '';
    } catch (e) {
      print(e.toString());
      return 'error';
    }
  }

  static Future<String> fetchAbsentHighResImage(
    String id,
    String date,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/ShowAttendanceSEventPhoto',
    );

    Map mapShowImage = {
      "EmployeeID": id,
      "Date": date,
    };

    print(mapShowImage);

    try {
      final response =
          await http.post(url, body: jsonEncode(mapShowImage), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      print(response.body);

      if (response.statusCode <= 200) {
        var jsonShowMessage = jsonDecode(response.body);
        if (jsonShowMessage['code'] == '100' ||
            jsonShowMessage['msg'] == 'Sukses') {
          if ((jsonShowMessage['data'] as List).isNotEmpty &&
              (jsonShowMessage['data'][0]['eventPhoto'] as String).isNotEmpty) {
            return jsonShowMessage['data'][0]['eventPhoto'];
          } else {
            return 'not available';
          }
        } else {
          return 'failed';
        }
      }
      return '';
    } catch (e) {
      print(e.toString());
      return 'error';
    }
  }
  // ~:NEW:~

  static Future<List<ModelAttendanceHistory>> fetchAttendanceHistory(
    String employeeID,
    String beginDate,
    String endDate,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/AttendanceHistory',
    );

    Map mapAttendanceHistory = {
      "EmployeeID": employeeID,
      "BeginDate": beginDate,
      "EndDate": endDate,
    };

    print(mapAttendanceHistory);

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
    double lat,
    double lng,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/InsertAttendance',
    );

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
        "Lat": lat, // mandatory
        "Lng": lng, // mandatory
      }
    };

    print(mapModifyAttendance);

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

  static Future<List<ModelResultMessage>> fetchModifyEventAttendance(
    String mode,
    String id,
    String branch,
    String shop,
    String date, // date
    String checkIn, // time
    double lat,
    double lng,
    String eventName,
    String eventPhoto,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/InsertAttendanceEvent',
    );

    Map mapModifyAttendance = {
      "Mode": mode,
      "Data": {
        "EmployeeID": id,
        "Branch": branch,
        "Shop": shop,
        "Date_": date,
        "CheckIn": checkIn,
        "Lat": lat,
        "Lng": lng,
        "EventName": eventName,
        "EventPhoto": eventPhoto,
      }
    };

    print(mapModifyAttendance);

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
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/InsertEmployeeActivityTimeStamp',
    );

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
    // print('Manager Activity Type URL');
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/MEmployeeActivitySM',
    );

    List<ModelActivities> managerActivityTypesList = [];

    print('Try and Catch');
    try {
      print('URL');
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      print('Entering If Else Statement');
      if (response.statusCode <= 200) {
        var jsonActivitytypes = jsonDecode(response.body);
        print('Status Code 200');
        if (jsonActivitytypes['code'] == '100' &&
            jsonActivitytypes['msg'] == 'Sukses') {
          print('Success');
          managerActivityTypesList = (jsonActivitytypes['data'] as List)
              .map<ModelActivities>((list) => ModelActivities.fromJson(list))
              .toList();

          return managerActivityTypesList;
        } else {
          print('Failed');
          return managerActivityTypesList;
        }
      } else {}

      print('Status Code 404');
      return managerActivityTypesList;
    } catch (e) {
      print('API Error: ${e.toString()}');
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
    String mode,
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
      "Pic1": images.length == 1 ? images[0] : '',
    };

    print(mapNewManagerActivity);

    List<ModelResultMessage2> activityTypesList = [];

    try {
      final response = await http
          .post(url, body: jsonEncode(mapNewManagerActivity), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      print(response.body);

      if (response.statusCode <= 200) {
        var jsonActivitytypes = jsonDecode(response.body);
        if (jsonActivitytypes['code'] == '100' &&
            jsonActivitytypes['msg'] == 'Sukses') {
          activityTypesList.addAll((jsonActivitytypes['data'] as List)
              .map<ModelResultMessage2>(
                  (list) => ModelResultMessage2.fromJson(list))
              .toList());

          return activityTypesList;
        } else {
          activityTypesList.add(ModelResultMessage2(resultMessage: '100'));
          return activityTypesList;
        }
      } else {
        activityTypesList.add(ModelResultMessage2(resultMessage: '204'));

        return activityTypesList;
      }
    } catch (e) {
      print(e.toString());
      activityTypesList.add(ModelResultMessage2(resultMessage: '404'));

      return activityTypesList;
    }
  }

  static Future<List<ModelSalesActivities>> fetchSalesActivity(
    String employeeID,
    String date,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/EmployeeActivity',
    );

    Map mapSalesActivity = {
      "EmployeeID": employeeID,
      "CurrentDate": date,
    };

    List<ModelSalesActivities> activityTypesList = [];

    try {
      final response =
          await http.post(url, body: jsonEncode(mapSalesActivity), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      if (response.statusCode <= 200) {
        var jsonSalesActivity = jsonDecode(response.body);
        if (jsonSalesActivity['code'] == '100' &&
            jsonSalesActivity['msg'] == 'Sukses') {
          activityTypesList = (jsonSalesActivity['data'] as List)
              .map<ModelSalesActivities>(
                  (list) => ModelSalesActivities.fromJson(list))
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

  // ~:OLD:~
  // static Future<List<ModelManagerActivities>> fetchOldManagerActivity(
  //   String employeeID,
  //   String date,
  // ) async {
  //   var url = Uri.https(
  //     'wsip.yamaha-jatim.co.id:2448',
  //     '/api/SIPSales/EmployeeActivitySM',
  //   );

  //   Map mapManagerActivity = {
  //     "EmployeeID": employeeID,
  //     "CurrentDate": date,
  //   };

  //   List<ModelManagerActivities> managerActivityList = [];

  //   try {
  //     final response =
  //         await http.post(url, body: jsonEncode(mapManagerActivity), headers: {
  //       'Content-Type': 'application/json',
  //     }).timeout(const Duration(minutes: 2));

  //     if (response.statusCode <= 200) {
  //       var jsonManagerActivity = jsonDecode(response.body);
  //       if (jsonManagerActivity['code'] == '100' &&
  //           jsonManagerActivity['msg'] == 'Sukses') {
  //         managerActivityList = (jsonManagerActivity['data'] as List)
  //             .map<ModelManagerActivities>(
  //                 (list) => ModelManagerActivities.fromJson(list))
  //             .toList();

  //         // print('Activity List: $managerActivityList');

  //         return managerActivityList;
  //       } else {
  //         return managerActivityList;
  //       }
  //     } else {}
  //     return managerActivityList;
  //   } catch (e) {
  //     print(e.toString());
  //     return managerActivityList;
  //   }
  // }

  static Future<List<ModelManagerActivities>> fetchManagerActivity(
    String employeeID,
    String date,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/EmployeeActivitySMHeader',
    );

    Map mapManagerActivity = {
      "EmployeeID": employeeID,
      "CurrentDate": date,
    };
    log('Map Activity: $mapManagerActivity');

    List<ModelManagerActivities> managerActivityList = [];

    try {
      final response =
          await http.post(url, body: jsonEncode(mapManagerActivity), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(minutes: 2));

      if (response.statusCode <= 200) {
        var jsonManagerActivity = jsonDecode(response.body);
        if (jsonManagerActivity['code'] == '100' &&
            jsonManagerActivity['msg'] == 'Sukses') {
          managerActivityList = (jsonManagerActivity['data'] as List)
              .map<ModelManagerActivities>(
                  (list) => ModelManagerActivities.fromJson(list))
              .toList();

          return managerActivityList;
        } else {
          return managerActivityList;
        }
      } else {}
      return managerActivityList;
    } catch (e) {
      print(e.toString());
      return managerActivityList;
    }
  }

  static Future<List<ModelManagerActivityDetails>> fetchManagerActivityDetails(
    String employeeID,
    String date,
    String actId,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/api/SIPSales/EmployeeActivitySMDetail',
    );

    Map mapManagerActivityDetails = {
      "EmployeeID": employeeID,
      "CurrentDate": date,
      "ActivityID": actId,
    };

    List<ModelManagerActivityDetails> managerActivityDetailList = [];

    try {
      final response = await http
          .post(url, body: jsonEncode(mapManagerActivityDetails), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(minutes: 2));

      if (response.statusCode <= 200) {
        var jsonManagerActivityDetails = jsonDecode(response.body);
        if (jsonManagerActivityDetails['code'] == '100' &&
            jsonManagerActivityDetails['msg'] == 'Sukses') {
          managerActivityDetailList =
              (jsonManagerActivityDetails['data'] as List)
                  .map<ModelManagerActivityDetails>(
                      (list) => ModelManagerActivityDetails.fromJson(list))
                  .toList();

          return managerActivityDetailList;
        } else {
          return managerActivityDetailList;
        }
      } else {}
      return managerActivityDetailList;
    } catch (e) {
      print(e.toString());
      return managerActivityDetailList;
    }
  }

  // ~:New:~
  static Future<Map<String, dynamic>> fetchCoordinatorDashboard(
    String employeeID,
    String date,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/DBSales/DBSales04',
    );

    Map mapCoordinatorDashboard = {
      "EmployeeID": employeeID,
      "EndDate": date,
    };
    log('Map Coordinator Dashboard: $mapCoordinatorDashboard');

    List<SalesmanDashboardModel> coordinatorDashboardList = [];

    try {
      final response = await http
          .post(url, body: jsonEncode(mapCoordinatorDashboard), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      if (response.statusCode <= 200) {
        var jsonResult = jsonDecode(response.body);
        if (jsonResult['code'] == '100' && jsonResult['msg'] == 'Sukses') {
          coordinatorDashboardList.addAll((jsonResult['data'] as List)
              .map<SalesmanDashboardModel>(
                  (data) => SalesmanDashboardModel.fromJson(data))
              .toList());
          log('Success');
          return {
            'status': 'sukses',
            'data': coordinatorDashboardList,
          };
        } else {
          log('Failed');
          return {
            'status': 'gagal',
            'data': coordinatorDashboardList,
          };
        }
      } else {
        log('Failed');
        return {
          'status': 'gagal',
          'data': 'Status code ${response.statusCode}, coba lagi.',
        };
      }
    } catch (e) {
      log('Error: ${e.toString()}');
      return {'status': 'error', 'data': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> fetchSalesmanDashboard(
    String employeeID,
    String date,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/DBSales/DBSales01',
    );

    Map mapSalesDashboard = {
      "EmployeeID": employeeID,
      "EndDate": date,
    };
    log('Map Sales Dashboard: $mapSalesDashboard');

    List<SalesmanDashboardModel> salesDashboardList = [];

    try {
      final response =
          await http.post(url, body: jsonEncode(mapSalesDashboard), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      if (response.statusCode <= 200) {
        var jsonResult = jsonDecode(response.body);
        if (jsonResult['code'] == '100' && jsonResult['msg'] == 'Sukses') {
          salesDashboardList.addAll((jsonResult['data'] as List)
              .map<SalesmanDashboardModel>(
                  (data) => SalesmanDashboardModel.fromJson(data))
              .toList());
          log('Success');
          return {
            'status': 'sukses',
            'data': salesDashboardList,
          };
        } else {
          log('Failed');
          return {
            'status': 'gagal',
            'data': salesDashboardList,
          };
        }
      } else {
        log('Failed');
        return {
          'status': 'gagal',
          'data': 'Status code ${response.statusCode}, coba lagi.',
        };
      }
    } catch (e) {
      log('Error: ${e.toString()}');
      return {'status': 'error', 'data': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> fetchFollowupDashboard(
    String employeeID,
    String date,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/DBSales/DBSales02',
    );

    Map mapFollowupDashboard = {
      "EmployeeID": employeeID,
      "EndDate": date,
    };
    log('Map Followup Dashboard: $mapFollowupDashboard');

    List<FollowUpDashboardModel> followupDashboardList = [];

    try {
      final response = await http
          .post(url, body: jsonEncode(mapFollowupDashboard), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      if (response.statusCode <= 200) {
        var jsonResult = jsonDecode(response.body);
        if (jsonResult['code'] == '100' && jsonResult['msg'] == 'Sukses') {
          followupDashboardList.addAll((jsonResult['data'] as List)
              .map<FollowUpDashboardModel>(
                  (data) => FollowUpDashboardModel.fromJson(data))
              .toList());
          log('Success');
          return {
            'status': 'sukses',
            'data': followupDashboardList,
          };
        } else if (jsonResult['code'] == '100' &&
            jsonResult['msg'].toString().toLowerCase().replaceAll(' ', '') ==
                'nodata') {
          log('No data');
          return {
            'status': 'sukses',
            'data': [],
          };
        } else {
          log('Failed');
          return {
            'status': 'gagal',
            'data': followupDashboardList,
          };
        }
      } else {
        log('Failed');
        return {
          'status': 'gagal',
          'data': 'Status code ${response.statusCode}, coba lagi.',
        };
      }
    } catch (e) {
      log('Error: ${e.toString()}');
      return {'status': 'error', 'data': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> fetchFollowupDealDashboard(
    String employeeID,
    String date,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/DBSales/DBSales03',
    );

    Map mapFollowupDealDashboard = {
      "EmployeeID": employeeID,
      "EndDate": date,
    };
    log('Map Followup Deal Dashboard: $mapFollowupDealDashboard');

    List<FollowUpDealDashboardModel> followupDealDashboardList = [];

    try {
      final response = await http
          .post(url, body: jsonEncode(mapFollowupDealDashboard), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      if (response.statusCode <= 200) {
        var jsonResult = jsonDecode(response.body);
        if (jsonResult['code'] == '100' && jsonResult['msg'] == 'Sukses') {
          followupDealDashboardList.addAll((jsonResult['data'] as List)
              .map<FollowUpDealDashboardModel>(
                  (data) => FollowUpDealDashboardModel.fromJson(data))
              .toList());
          log('Success');
          return {
            'status': 'sukses',
            'data': followupDealDashboardList,
          };
        } else if (jsonResult['code'] == '100' &&
            jsonResult['msg'].toString().toLowerCase().replaceAll(' ', '') ==
                'nodata') {
          log('No data');
          return {
            'status': 'sukses',
            'data': [],
          };
        } else {
          log('Failed');
          return {
            'status': 'gagal',
            'data': followupDealDashboardList,
          };
        }
      } else {
        log('Failed');
        return {
          'status': 'gagal',
          'data': 'Status code ${response.statusCode}, coba lagi.',
        };
      }
    } catch (e) {
      log('Error: ${e.toString()}');
      return {'status': 'error', 'data': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> fetchUpdateFollowupDashboard(
    String employeeID,
    String mobilePhone,
    String prospectDate,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/DBSales/DBSales02/ProspectDetail',
    );

    Map mapUpdateFollowupDashboard = {
      "EmployeeID": employeeID,
      "MobilePhone": mobilePhone,
      "ProspectDate": prospectDate,
    };
    log('Map Update Followup Dashboard: $mapUpdateFollowupDashboard');

    List<UpdateFollowUpDashboardModel> updateFollowupDashboardList = [];

    try {
      final response = await http
          .post(url, body: jsonEncode(mapUpdateFollowupDashboard), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

      log('Response: ${response.body}');

      if (response.statusCode <= 200) {
        log('Status Code: ${response.statusCode}');
        var jsonResult = jsonDecode(response.body);
        if (jsonResult['code'] == '100' &&
            jsonResult['msg'] == 'Sukses' &&
            jsonResult['data'] != null) {
          log('Data: ${((jsonResult['data'] as List).length)}');
          updateFollowupDashboardList.addAll((jsonResult['data'] as List)
              .map<UpdateFollowUpDashboardModel>(
                  (e) => UpdateFollowUpDashboardModel.fromJson(e)));
          log('Success');
          return {
            'status': 'sukses',
            'data': updateFollowupDashboardList,
          };
        } else {
          log('Failed');
          return {
            'status': 'gagal',
            'data': updateFollowupDashboardList,
          };
        }
      } else {
        log('Failed');
        return {
          'status': 'gagal',
          'data': 'Status code ${response.statusCode}, coba lagi.',
        };
      }
    } catch (e) {
      log('API Error: ${e.toString()}');
      return {'status': 'error', 'data': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> saveFollowup(
    String employeeID,
    String mobilePhone,
    String prospectDate,
    int line,
    String fuDate,
    String fuResult,
    String fuMemo,
    String nextFUDate,
  ) async {
    var url = Uri.https(
      'wsip.yamaha-jatim.co.id:2448',
      '/DBSales/DBSales02/ModifyFU',
    );

    Map mapSaveFollowupStatus = {
      "EmployeeID": employeeID,
      "MobilePhone": mobilePhone,
      "ProspectDate": prospectDate,
      "Line": line,
      "FUDate": fuDate,
      "FUResult": fuResult,
      "FUMemo": fuMemo,
      "NextFUDate": nextFUDate,
    };
    log('Map Save Followup: $mapSaveFollowupStatus');

    try {
      final response = await http
          .post(url, body: jsonEncode(mapSaveFollowupStatus), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 60));

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
    } catch (e) {
      log('Error: ${e.toString()}');
      return {'status': 'error', 'data': e.toString()};
    }
  }
  // ~:New:~
}
