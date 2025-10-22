import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:sip_sales_clean/core/constant/api.dart';
import 'package:sip_sales_clean/data/models/radius_checker.dart';
import 'package:sip_sales_clean/domain/repositories/radius_checker_domain.dart';

class RadiusCheckerRepoImp implements RadiusCheckerRepo {
  @override
  Future<Map<String, dynamic>> checkRadius(
    double userLat,
    double userLng,
    double currentLat,
    double currentLng,
  ) async {
    // Simulate a network call
    Uri uri = Uri.https(
      APIConstants.baseUrl,
      APIConstants.radiusCheckerEndpoint,
    );

    Map body = {
      "LatDealer": userLat,
      "LngDealer": userLng,
      "Lat": currentLat,
      "Lng": currentLng,
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
        log('Radius Success');
        return {
          'status': 'success',
          'data': (res['Data'] as List)
              .map((e) => RadiusCheckerModel.fromJson(e))
              .toList()[0],
        };
      } else {
        log('Radius Fail');
        return {
          'status': 'fail',
          'data': (res['Data'] as List)
              .map((e) => RadiusCheckerModel.fromJson(e))
              .toList()[0],
        };
      }
    } else {
      log('Radius Response: ${response.statusCode}');
      return {
        'status': 'fail',
        'data': RadiusCheckerModel(
          isClose: response.statusCode.toString(),
          eventPhoto: '',
          eventPhotoThumb: '',
          eventPhotoUrl: '',
          gMapUrl: '',
        ),
      };
    }
  }
}
