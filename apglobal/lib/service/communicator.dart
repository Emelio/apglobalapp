
import 'dart:convert';
import 'dart:io';

import 'package:apglobal/screens/myapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Communicator {

  static Future<bool> login(String email, String password) async {
    String url = 'https://apgloballimited.com/api/users/login';

    http.Response response = await http.post(url, body: json.encode({'Email': email.toLowerCase(), 'Password': password}), headers:  {"Content-Type": "application/json"});

    print(response.body);
    var jsonbody = json.decode(response.body);

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('token', jsonbody['token']);
  
    if (jsonbody['token'] != null){
      return true;
    }else{
      return false;
    }
  }

  static Future<String> addTracking(Map<String, dynamic> data) async {
    String url = 'https://apgloballimited.com/api/command/addTracking';

    SharedPreferences pre = await SharedPreferences.getInstance(); 
    String token = pre.getString('token');

    var jsonData = json.encode(data);

    http.Response response = await http.post(url, body: jsonData, headers: {HttpHeaders.authorizationHeader: "Bearer $token", "Content-Type": "application/json"});

    print(response.body);
    print(response.statusCode);
    return response.body;
  } 

  static Future<Map<String, dynamic>> getTracking() async {

    SharedPreferences pre = await SharedPreferences.getInstance(); 
    String token = pre.getString('token');
    String url = 'https://apgloballimited.com/api/command/getTracking';

    http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"}); 
print(response.body);
print(response.statusCode);
    var data = json.decode(response.body);
    return data;
    
  }

  static Future<dynamic> getDevice(String id) async {

    String url = "https://apgloballimited.com/api/command/getDevice/$id";

    SharedPreferences pre = await SharedPreferences.getInstance(); 
    String token = pre.getString('token');

      http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"},); 
      SharedPreferences pref = await SharedPreferences.getInstance(); 
print(response.statusCode);
print(response.body);
      if(response.body != null && response.body != '') {
        if(response.statusCode == 200){
          pref.setString('device', response.body);
        }
        
      }
      return response.body;

  }

  static Future<dynamic> getDeviceList() async {
    String url = "https://apgloballimited.com/api/command/getListOfDevices";

    SharedPreferences pre = await SharedPreferences.getInstance(); 
    String token = pre.getString('token');

    http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"},);

    print(response.statusCode);

    if(response.statusCode == 401){
      pre.remove('token');
      return 'login';      
    }else if(response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      return jsonData;
    }else{
      return '';
    }

    
  }

  static Future<dynamic> updateStatus(String status, String state, String id) async {

    SharedPreferences pre = await SharedPreferences.getInstance(); 
    String token = pre.getString('token');

    String userId = base64stuff(token);
    Map<String, dynamic> map = json.decode(userId);
    String user = map['nameid'];

    String url = "https://apgloballimited.com/api/command/updateStatus/$status/$state/$id";


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

    String url = "https://apgloballimited.com/api/users/resetpassword/$email/0";

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('email', email);

    http.Response response = await http.get(url);

    print(response.statusCode);

    return response.body; 
  }

  static Future<Map<String, dynamic>> updatePassword(String password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString('email');
    String code = pref.getString('code');

    var base = base64String(email.toLowerCase()+":"+code);
    print(email);
    print(code);
    print(base);

    String url = 'https://apgloballimited.com/api/users/updatePassword/$password/$base';

    http.Response response = await http.get(url);

    print(response.body);

    Map<String, dynamic> map = json.decode(response.body);

    return map; 
    
  }

  static Future<String> checkVerificationCode(String code) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString('email').toLowerCase();
    pref.setString('code', code);

  
    String url = 'https://apgloballimited.com/api/users/resetpassword/$email/$code';
    http.Response response = await http.get(url);

    print(response.statusCode);
    print(response.body);

    return response.body;
  }

  static base64String(String string){
    var bytes = utf8.encode(string);
    var base64Str = base64.encode(bytes);
    return base64Str; 
  }

}