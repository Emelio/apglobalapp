
import 'dart:convert';
import 'dart:io';

import 'package:apglobal/screens/myapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Communicator {

  static String baseUrl = 'https://apgloballimited.com/';

  static Future<bool> login(String email, String password) async {
    String url = baseUrl+'api/users/login/';

    http.Response response = await http.get(url+email+"/"+password);

    print(response.body);
    print(response.statusCode);
    var jsonbody = json.decode(response.body);

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('token', jsonbody['token']);


    print(jsonbody['token']);
  
    if (jsonbody['token'] != null){
      return true;
    }else{
      return false;
    }
  }

  static Future<List<dynamic>> getCard() async {
    String url = baseUrl+'api/billing/getCards';

    SharedPreferences pre = await SharedPreferences.getInstance();
    String token = pre.getString('token');

    http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    print(response.body);
    print(response.statusCode);

    List<dynamic> cards = json.decode(response.body);
    return cards;

  }

  static Future<Map<String, dynamic>> subscription() async {
    String url = baseUrl+'api/billing/getSunscription';

     SharedPreferences pre = await SharedPreferences.getInstance();
    String token = pre.getString('token');

    http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    print(response.body);

    Map<String, dynamic> map = json.decode(response.body);

    return map;

  }

  

  static Future<String> addCard(Map<String, dynamic> data) async {
    String url = baseUrl+'api/billing/registerCard';

    SharedPreferences pre = await SharedPreferences.getInstance();
    String token = pre.getString('token');

    var jsonData = json.encode(data);

    http.Response response = await http.post(url, body: jsonData, headers: {HttpHeaders.authorizationHeader: "Bearer $token", "Content-Type": "application/json"});

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

  static Future<String> verifyCard(String cardNumber, double amount) async {
    String url = baseUrl+'api/billing/updateStage/$cardNumber/$amount';

    SharedPreferences pre = await SharedPreferences.getInstance();
    String token = pre.getString('token');

    http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    print(cardNumber);
    print(response.body);
    print(response.statusCode);
    return response.body;
  }

  static Future<String> addTracking(Map<String, dynamic> data) async {
    String url = baseUrl+'api/command/addTracking';

    SharedPreferences pre = await SharedPreferences.getInstance(); 
    String token = pre.getString('token');

    var jsonData = json.encode(data);

    print(jsonData);

    http.Response response = await http.post(url, body: jsonData, headers: {HttpHeaders.authorizationHeader: "Bearer $token", "Content-Type": "application/json"});

    print('hi');
    print(response.body);
    print(response.statusCode);
    return response.body;

  } 

  static Future<Map<String, dynamic>> getTracking() async {

    SharedPreferences pre = await SharedPreferences.getInstance(); 
    String token = pre.getString('token');
    String url = baseUrl+'api/command/getTracking';

    http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"}); 

    Map<String, dynamic> data = json.decode(response.body);

    print(data);
    return data;
    
  }

  static Future<dynamic> getDevice() async {

    var carList = await getDeviceList();
  
    print(carList);

    String url = baseUrl+"api/command/getDevice/${carList[0]}";

    SharedPreferences pre = await SharedPreferences.getInstance(); 
    String token = pre.getString('token');

      http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"},); 
      SharedPreferences pref = await SharedPreferences.getInstance(); 
print("Status");
print(response.statusCode);
print(response.body);
      if(response.body != null && response.body != '') {
        if(response.statusCode == 200){
          pref.setString('device', response.body);
          return response.body;
        }else{
         return 'error';
        }
        
      }else{
        
      }
      
      return response.body;

  }

  static Future<dynamic>  getDeviceList() async {
    String url = baseUrl+"api/command/getListOfDevices";

    SharedPreferences pre = await SharedPreferences.getInstance(); 
    String token = pre.getString('token');

    http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"},);

    print('hi');
    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 401){
      pre.remove('token');
      return 'login';      
    }else if(response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print(jsonData);
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

    String url = baseUrl+"api/command/updateStatus/$status/$state/$id";

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

    String url = baseUrl+"api/users/resetpassword/$email/0";

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

  static Future<Map<String, dynamic>> getSubscription(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token');
    Map<String, dynamic> map  = Map<String, dynamic>();

    String url = baseUrl+'api/billing/getSunscription';
    http.Response response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token", "Content-Type": "application/json"});

    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 200) {
      map = json.decode(response.body);
    }

    if(response.statusCode == 401){
      Navigator.pushNamedAndRemoveUntil(context, 'login', (Route<dynamic> route) => false);
    }

    return map;
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
    String url = baseUrl+'api/billing/makeSubscription';

    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token');


    http.Response response = await http.post(url, body: json.encode(map), headers: {HttpHeaders.authorizationHeader: "Bearer $token", "Content-Type": "application/json"},);

    print(response.statusCode);
    print(response.body);
    return response.body;

  }


}