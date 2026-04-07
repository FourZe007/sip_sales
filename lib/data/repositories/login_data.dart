import 'dart:convert';
import 'dart:developer';

import 'package:sip_sales_clean/core/constant/api.dart';
import 'package:sip_sales_clean/data/models/employee.dart';
import 'package:sip_sales_clean/data/models/result_message.dart';
import 'package:sip_sales_clean/domain/repositories/login_domain.dart'
    show LoginRepo;
import 'package:http/http.dart' as http;

class LoginRepoImp implements LoginRepo {
  @override
  Future<Map<String, dynamic>> login(
    String username,
    String password,
    String uuid,
    String device,
  ) async {
    // Simulate a network call
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.loginEndpoint,
    );
    log('Uri: $uri');

    Map body = {
      "EmployeeID": username,
      "DecryptedPassword": password,
      'DeviceID': uuid,
      'DeviceName': device,
    };
    log('Map Body: $body');

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    log('Response: $response');

    // return LoginModel.fromJson(jsonDecode(res.body));

    if (response.statusCode == 200) {
      log('Response: ${response.statusCode}');
      final res = jsonDecode(response.body);
      log("${res['Msg']}, ${res['Code']}");
      if (res['Msg'].toString().toLowerCase() == 'sukses' &&
          res['Code'] == '100') {
        final dataList =
            (res['Data'] as List?)
                ?.map((e) => EmployeeModel.fromJson(e))
                .toList() ??
            [];
        if (dataList.isEmpty) {
          return {
            'status': 'fail',
            'data': EmployeeModel(
              flag: 0,
              memo: 'Data tidak ditemukan',
              employeeID: '',
              employeeName: '',
              branch: '',
              shop: '',
              bsName: '',
              locationID: '',
              locationName: '',
              latitude: 0,
              longitude: 0,
              profilePicture: '',
              code: 0,
            ),
          };
        } else {
          final creds = dataList[0];
          log('Creds jsonEncoder: ${jsonEncode(creds.toJson())}');

          if (creds.flag == 1) {
            log('Creds flag is equal to 1');
            return {
              'status': 'success',
              'data': (res['Data'] as List)
                  .map((e) => EmployeeModel.fromJson(e))
                  .toList()[0],
            };
          } else {
            log('Creds flag is not equal to 1');
            return {
              'status': 'fail',
              'data': (res['Data'] as List)
                  .map((e) => EmployeeModel.fromJson(e))
                  .toList()[0],
            };
          }
        }
      } else {
        log('Login Fail');
        final failData = res['Data'];
        final failMemo = (failData != null && (failData as List).isNotEmpty)
            ? EmployeeModel.fromJson(failData[0]).memo
            : res['Msg']?.toString() ?? 'Login gagal';
        final failFlag = (failData != null && (failData as List).isNotEmpty)
            ? EmployeeModel.fromJson(failData[0]).flag
            : 0;
        return {
          'status': 'fail',
          'data': EmployeeModel(
            flag: failFlag,
            memo: failMemo,
            employeeID: '',
            employeeName: '',
            branch: '',
            shop: '',
            bsName: '',
            locationID: '',
            locationName: '',
            latitude: 0,
            longitude: 0,
            profilePicture: '',
            code: 0,
          ),
        };
      }
    } else {
      log('Login Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'data': EmployeeModel(
          flag: 0,
          memo: response.statusCode.toString(),
          employeeID: '',
          employeeName: '',
          branch: '',
          shop: '',
          bsName: '',
          locationID: '',
          locationName: '',
          latitude: 0,
          longitude: 0,
          profilePicture: '',
          code: 0,
        ),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> logout() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(
    String employeeId,
    String currentPassword,
    String newPassword,
  ) async {
    // Simulate a network call
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.forgotPasswordEndpoint,
    );

    Map body = {
      "EmployeeID": employeeId,
      "CurrentPassword": currentPassword,
      "NewPassword": newPassword,
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
      if (res['msg'].toLowerCase() == 'sukses' && res['code'] == '100') {
        final message = (res['data'] as List)
            .map((e) => ResultMessageModel.fromJson(e))
            .toList();

        if (message.isNotEmpty) {
          log('Change Password Succeed');
          return {
            'status': 'success',
            'data': message[0].resultMessage,
          };
        } else {
          log('Change Password Failed');
          return {
            'status': 'fail',
            'data': message[0].resultMessage,
          };
        }
      } else {
        log('Change Password Failed');
        return {
          'status': 'fail',
          'data': res['msg'],
        };
      }
    } else {
      log('Change Password Failed');
      return {
        'status': 'fail',
        'data': response.statusCode.toString(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
    String employeeId,
  ) async {
    // Simulate a network call
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.resetPasswordEndpoint,
    );

    Map body = {"EmployeeID": employeeId};
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
      if (res['msg'].toLowerCase() == 'sukses' && res['code'] == '100') {
        final message = (res['data'] as List)
            .map((e) => ResultMessageModel.fromJson(e))
            .toList();

        if (message.isNotEmpty) {
          log('Change Password Succeed');
          return {
            'status': 'success',
            'data': message[0].resultMessage,
          };
        } else {
          log('Change Password Failed');
          return {
            'status': 'fail',
            'data': message[0].resultMessage,
          };
        }
      } else {
        log('Change Password Failed');
        return {
          'status': 'fail',
          'data': res['msg'],
        };
      }
    } else {
      log('Change Password Failed');
      return {
        'status': 'fail',
        'data': response.statusCode.toString(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> requestId(
    String phoneNumber,
  ) async {
    // Simulate a network call
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.requestIdEndpoint,
    );

    Map body = {"PhoneNo": phoneNumber};
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
      if (res['msg'].toLowerCase() == 'sukses' && res['code'] == '100') {
        final message = (res['data'] as List)
            .map((e) => ResultMessageModel.fromJson(e))
            .toList();

        if (message.isNotEmpty) {
          log('Change Password Succeed');
          return {
            'status': 'success',
            'data': message[0].resultMessage,
          };
        } else {
          log('Change Password Failed');
          return {
            'status': 'fail',
            'data': message[0].resultMessage,
          };
        }
      } else {
        log('Change Password Failed');
        return {
          'status': 'fail',
          'data': res['msg'],
        };
      }
    } else {
      log('Change Password Failed');
      return {
        'status': 'fail',
        'data': response.statusCode.toString(),
      };
    }
  }
}
