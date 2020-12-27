
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiEndpoints {
  static String baseUrl = 'https://api.apgloballimited.com/';

  static Future<dynamic> all() async {
    String url = baseUrl+'api/relay/all';

    Response response = await get(url);

    print(response.body);
    print(response.statusCode);
    print(url);
    print('track');

    if(response.statusCode == 200){
      return json.decode(response.body);
    }else{
      return null;
    }
  }

  static Future<dynamic> updateStatus(String device, String status, String value) async {
    String url = baseUrl + 'api/relay/updateStatus/$device/$status/$value';

    SharedPreferences pre = await SharedPreferences.getInstance();
    String token = pre.getString('token');

    Response response = await get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token", "Content-Type": "application/json"});

    print(response.body);
    print(response.statusCode);
    print(url);
    print('updateStatus');

  }

  static Future<dynamic> tracking(Map<String, dynamic> data) async {
    String url = baseUrl + 'api/relay/tracking';

    SharedPreferences pre = await SharedPreferences.getInstance();
    String token = pre.getString('token');


    Response response = await post(url, body: json.encode(data), headers: {HttpHeaders.authorizationHeader: "Bearer $token", "Content-Type": "application/json"});

    print(response.body);
    print(response.statusCode);
    print(url);
    print(json.encode(data));
    print('tracking');

  }

}