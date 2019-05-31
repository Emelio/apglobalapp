
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Communicator {

  static Future<bool> login(String email, String password) async {
    String url = 'https://apgloballimited.com/api/users/login';

    http.Response response = await http.post(url, body: json.encode({'Email': email, 'Password': password}), headers:  {"Content-Type": "application/json"}); 
    var jsonbody = json.decode(response.body);

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('token', jsonbody['token']);
  
    if (jsonbody['token'] != null){
      return true;
    }else{
      return false;
    }
  }

  static Future<dynamic> getDevice(String userId) async {

    String url = "https://apgloballimited.com/api/command/getDevice/$userId";

    SharedPreferences pre = await SharedPreferences.getInstance(); 
    String token = pre.getString('token');

    try {
      http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"},); 
      print(response.body);
      SharedPreferences pref = await SharedPreferences.getInstance(); 

      if(response.body != null && response.body != '') {
        pref.setString('device', response.body);
      }
      

      return response.body;
    } catch (e) {
      print("test: $e");
    }   
  }

  static Future<dynamic> updateStatus(String status, String state) async {

    SharedPreferences pre = await SharedPreferences.getInstance(); 
    String token = pre.getString('token');

    String userId = base64stuff(token);
    Map<String, dynamic> map = json.decode(userId);
    String user = map['nameid'];

    String url = "https://apgloballimited.com/api/command/updateStatus/$status/$state/$user";


    http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"},);

    print(response.body);
    return response.body;
  }

  static base64stuff(String token) {
    var ins = token.split(".");
    var base64Str = base64.decode(ins[1]);
    var string = utf8.decode(base64Str);
    return string;
  }

  static Future<String> resetPassword(String email) async {

    String url = "https://apgloballimited.com/api/command/resetPassword/$email";

    http.Response response = await http.get(url);

    print(response.statusCode);

    return response.body; 
  }

}