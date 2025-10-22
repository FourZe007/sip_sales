import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:sip_sales_clean/core/constant/api.dart';
import 'package:sip_sales_clean/data/models/result_message_2.dart';
import 'package:sip_sales_clean/domain/repositories/image_domain.dart';

class ImageRepoImp implements ImageRepo {
  @override
  Future<Map<String, dynamic>> uploadProfilePicture(
    String mode,
    String employeeId,
    String img,
  ) async {
    // Simulate a network call
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.insertProfilePictureEndpoint,
    );

    Map body = {
      "Mode": mode,
      "EmployeeID": employeeId,
      'Photo': img,
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
      if (res['Msg'] == 'Sukses' && res['Code'] == '100') {
        log('Success');
        return {
          'status': 'success',
          'code': res['Code'],
          'data': (res['Data'] as List)
              .map((e) => ResultMessageModel2.fromJson(e))
              .toList()[0],
        };
      } else {
        log('Fail');
        return {
          'status': 'fail',
          'code': res['Code'],
          'data': ([]).map((e) => ResultMessageModel2.fromJson(e)).toList()[0],
        };
      }
    } else {
      log('Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'code': response.statusCode,
        'data': ([]).map((e) => ResultMessageModel2.fromJson(e)).toList()[0],
      };
    }
  }
}
