import 'dart:convert';
import 'dart:developer';

import 'package:sip_sales_clean/core/constant/api.dart';
import 'package:sip_sales_clean/data/models/employee.dart';
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
    Uri uri = Uri.https(APIConstants.baseUrl, APIConstants.loginEndpoint);

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

    if (response.statusCode <= 200) {
      log('Response: ${response.statusCode}');
      final res = jsonDecode(response.body);
      log("${res['Msg']}, ${res['Code']}");
      if (res['Msg'].toLowerCase() == 'sukses' && res['Code'] == '100') {
        log('Login Success');
        return {
          'status': 'success',
          'data': EmployeeModel.fromJson(res['Data'][0]),
        };
      } else {
        log('Login Fail');
        return {
          'status': 'fail',
          'data': EmployeeModel(
            flag: 0,
            memo: EmployeeModel.fromJson(res['Data'][0]).memo,
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
}
