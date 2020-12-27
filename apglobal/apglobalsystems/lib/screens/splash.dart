import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget{

  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((result) async {
      if (result.getString('token') != null) {
        Navigator.pushReplacementNamed(context, 'home');

        //runApp(Home());
      }else{
        Navigator.pushReplacementNamed(context, 'login');

      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: null,
    );
  }
}