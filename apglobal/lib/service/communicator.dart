
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Communicator {

  static Future<bool> login(String email, String password) async {
    String url = 'https://apgloballimited.com/api/users/login';

    Response response = await Dio().post(url, data: {'Email': email, 'Password': password});

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('token', response.data['token'].toString());

    if (response.data['token'] != null){
      return true;
    }else{
      return false;
    }
  }

  static Future<dynamic> getDevice(String userId) async {

    String url = "localhost:5000/api/command/getDevice/$userId";

    SharedPreferences pre = await SharedPreferences.getInstance(); 
    String token = pre.getString('token');

    intercept(token);

      Response response = await Dio().get(url); 
      return response.data;

  }

  static intercept(String token){
    Dio().interceptors.add(InterceptorsWrapper(
    onRequest:(Options options) async{
        //...If no token, request token firstly.
        //Set the token to headers 
        options.headers["token"] = token;
        return options; //continue   
    }
));
  }
}