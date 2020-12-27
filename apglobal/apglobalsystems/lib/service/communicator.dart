
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:apglobalsystems/Model/Tracking.dart';
import 'package:apglobalsystems/Model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Communicator {


  static bool constDrawer=false;


  static String baseUrl = 'https://api.apgloballimited.com/';

  static Future<dynamic> killswitch(String device, String status) async {
    String url = baseUrl+'api/relay/killswitch/$status/$device/power';

    http.Response response = await http.get(url);

    print(response.body);
    print(response.statusCode);
    print(url);
    print('track');
  }

  static Future<dynamic> arm(String device, String status) async {
    String url = baseUrl+'api/relay/killswitch/$status/$device/arm';

    http.Response response = await http.get(url);

    print(response.body);
    print(response.statusCode);
    print(url);
    print('track');
  }

  static Future<dynamic> monitor(String device, String status) async {
    String url = baseUrl+'api/relay/killswitch/$status/$device/monitor';

    http.Response response = await http.get(url);

    print(response.body);
    print(response.statusCode);
    print(url);
    print('track');
  }

  static Future<bool> login(String email, String password) async {
    String url = baseUrl+'api/auth/login/$email/$password';
    print(url);

    http.Response response = await http.get(url);

    print(response.body);
    print(response.statusCode);
    print('login');

    if(response.statusCode == 400){
      return null;
    }

    if(response.statusCode == 500){
      return false;
    }

    var result = json.decode(response.body);

    SharedPreferences pref = await SharedPreferences.getInstance();

    print(json.encode(result['user']));
    print('encoding');
    if (result['token'] != null){
      pref.setString('token', result['token']);
      pref.setString('userData', json.encode(result['user']));
      return true;
    }else{
      return false;
    }
  }

  static Future<List<Devices>> searchVehicles(String query, String id) async {

    String url = baseUrl+'api/main/GetVehicles/$query/$id';

    http.Response response = await http.get(url);

    print("searchVehicles");
    print(response.body);
    print(response.statusCode);
    print(baseUrl+'api/main/GetVehicles/$query/$id');

    if(response.statusCode == 400){
      return null;
    }else if(response.statusCode == 500) {
      return null;
    } else if(response.statusCode == 404){
      return null;
    }else{
      List<dynamic> results = json.decode(response.body);
      List<Devices> devices = List<Devices>();

      results.forEach((element) {
        devices.add(Devices.fromJson(element['device']));
      });
      return devices;
    }

  }

  Future<List<dynamic>> getDevices() async {

    SharedPreferences pref = await SharedPreferences.getInstance();

    var user = json.decode(pref.getString('userData'));

    http.Response response = await http.get(baseUrl+'api/main/GetDevices/${user['id']}');

    print(response.body);
    print(response.statusCode);
    print(baseUrl+'api/main/GetDevices/${user['id']}');
    print('getDevices');

    if(response.statusCode == 400){
      return null;
    }else if(response.statusCode == 500) {
      return null;
    } else if(response.statusCode == 404){
      return null;
    }

    return json.decode(response.body);
  }

  static Future<bool> register(String email, String password, String phone) async {
    String url = baseUrl+'api/auth/register/$email/$phone/$password';
    print(url);

    http.Response response = await http.get(url);

    print(response.body);
    print(response.statusCode);

    if(response.statusCode == 400){
      return false;
    }else if(response.statusCode == 500) {
      return false;
    } else if(response.statusCode == 404){
      return false;
    }

    var result = json.decode(response.body);

    SharedPreferences pref = await SharedPreferences.getInstance();


    pref.setString('token', result['token']);
    pref.setString('userData', json.encode(result['user']));


    if (result['token'] != null || result['token'] != ""){
      return true;
    }else{
      return false;
    }
  }

  static Future<Map<String, dynamic>> getCard() async {

    SharedPreferences pre = await SharedPreferences.getInstance();
    String token = pre.getString('token');
    Map<String, dynamic> userData = json.decode(pre.getString('userData'));

    String url = baseUrl+'getCard?code=tB7mc0nL8cIieou2DMQzZUl0dzatKz0/F/yP1RedhNUa2QMTkqahYw==&id=${userData['id']}';

    http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    print(response.body);
    print(response.statusCode);

    if(response.statusCode == 200){
      return json.decode(response.body);
    }else{
      return Map();
    }
  }

  static Future<String> addCard(Map<String, dynamic> data) async {
    String url = baseUrl+'addCard?code=bLAegmIdeqS8vc3TtthUrtyQRkTJYseMHbhn/nyH46bpKG1B9FT5EA==';

    SharedPreferences pre = await SharedPreferences.getInstance();
    String token = pre.getString('token');

    var jsonData = json.encode(data);

    http.Response response = await http.post(url, body: jsonData, headers: {HttpHeaders.authorizationHeader: "Bearer $token", "Content-Type": "application/json"});

    print("transaction status");
    print(response.body);
    print(response.statusCode);
    return response.body;

  }

  static Future<String> removeCard(String cardNumber) async {

    String url = baseUrl+'api/billing/removeCard/$cardNumber';

    SharedPreferences pre = await SharedPreferences.getInstance();
    String token = pre.getString('token');

    http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    print(response.body);
    print(response.statusCode);
    return response.body;
  }

  static Future<String> paySub(String type, String cardNumber, String cvv, String expire) async {
    String url = baseUrl+'api/billing/makeSubscription';

    SharedPreferences pre = await SharedPreferences.getInstance();
    String token = pre.getString('token');
    
    http.Response response = await http.post(url, 
    body: {'UserId': '', 'ItemId': type, 'CardNumber': cardNumber, 'Cvv': cvv, 'ExpirationDate': expire}, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    print(response.body);
    print(response.statusCode);
    return response.body;

  }

  static Future<String> verifyCard(String cardNumber, double amount, String userID) async {
    String url = baseUrl+'verifyCreditCard?code=YzNahA7i5ozmCwqrhQLyPtJ0O14NuyrtVc7/qg9Tj7YkUz5zk3OruA==&cardNumber=$cardNumber&userID=$userID&amount=$amount';

    SharedPreferences pre = await SharedPreferences.getInstance();
    String token = pre.getString('token');

    http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    print("verify card");
    print(response.body);
    print(response.statusCode);
    return response.body;
  }

  static Future<String> addTracking(Tracking data) async {
    String url = baseUrl+'api/main/UpdateTracking';

    SharedPreferences pre = await SharedPreferences.getInstance(); 
    String token = pre.getString('token');

    var jsonData = json.encode(data);

    print(jsonData);

    http.Response response = await http.post(url, body: jsonData, headers: {HttpHeaders.authorizationHeader: "Bearer $token", "Content-Type": "application/json"});
    return response.body;

  } 

  Future<dynamic> getTrackingData(dynamic device) async {

    SharedPreferences pre = await SharedPreferences.getInstance(); 
    String token = pre.getString('token');
    var user = json.decode(pre.getString('userData'));
    String url = baseUrl+'api/main/GetTracking/${user['id']}/$device';

    http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    print("tracking data");
    print(response.body);
    print(response.statusCode);
    print(baseUrl+'api/main/GetTracking/${user['id']}/$device');



    if(response.statusCode == 404 ){
      return null;
    }else if(response.statusCode == 204) {
      return null;
    } else {
      return json.decode(response.body);
    }


    
  }



  Future<dynamic> updateStatus(String device, String status, String value) async {

    SharedPreferences pre = await SharedPreferences.getInstance(); 
    String token = pre.getString('token');

    String url = baseUrl+"api/relay/updateStatus/$device/$status/$value";

    http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"},);

    if(response.statusCode == 200){
      pre.setString('userData', response.body);
    }


    return response.body;
  }

  static base64stuff(String token) {
    var ins = token.split(".");
    var base64Str = base64.decode(ins[1]);
    var string = utf8.decode(base64Str);
    return string;
  }

  static Future<String> resetPassword(String email) async {

    String url = baseUrl+"api/users/resetpassword/$email/0";
    print(url);

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

    String url = baseUrl+'api/users/updatePassword/$password/$base';

    http.Response response = await http.get(url);

    print(response.body);

    Map<String, dynamic> map = json.decode(response.body);

    return map; 
    
  }

  static Future<String> checkVerificationCode(String code) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString('email').toLowerCase();
    pref.setString('code', code);

  
    String url = baseUrl+'api/users/resetpassword/$email/$code';
    http.Response response = await http.get(url);

    print(response.statusCode);
    print(response.body);

    return response.body;
  }

  static Future<dynamic> getSubscription() async {

      try{
        SharedPreferences pref = await SharedPreferences.getInstance();
        String token = pref.getString('token');
        print(pref.getString('userData'));
        print("getSubscription");
        Map<String, dynamic> userData = json.decode(pref.getString('userData'));
        Map<String, dynamic> map  = Map<String, dynamic>();


        String url = baseUrl+'api/billing/GetCurrentSubscription/${userData['id']}';
        http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token", "Content-Type": "application/json"});

        if(response.statusCode == 200) {
          map = json.decode(response.body);

          if(map['type'] == 'PayAsYouGo'){
            if(map['commands'] < 1) {
              return null;
            }else{
              return map;
            }
          }else{
            DateTime date = DateTime.now();
            DateTime subDate = DateTime.parse(map['expirationDate']);
            if(date.isBefore(subDate)){
              return map;
            }else {
              return null;
            }
          }

        }else{
          return null;
        }
      } on SocketException catch (ex){
        return null;
      }


  }

  static Future<String> updateCommands() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token');

    String url = baseUrl+'api/billing/updateSub';
    http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token", "Content-Type": "application/json"});



  }

  static base64String(String string){
    var bytes = utf8.encode(string);
    var base64Str = base64.encode(bytes);
    return base64Str; 
  }

  static Future<String> payForSubscription(Map<String, dynamic> map) async {
    String url = baseUrl+'makeSubscription?code=eTyHiFqJxHQ/rH22TryKdBBfUUkYMkByjpesJ6X2Rmvy3yaHJnNLPw==';

    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token');


    http.Response response = await http.post(url, body: json.encode(map), headers: {HttpHeaders.authorizationHeader: "Bearer $token", "Content-Type": "application/json"},);


    print(response.statusCode);
    print(response.body);
    return response.body;

  }


}