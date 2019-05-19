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
}