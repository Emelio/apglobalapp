
import 'package:apglobal/screens/password.dart';
import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apglobal/screens/home.dart';

import 'home.dart';

class MyApp extends StatelessWidget {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  MyApp(){
    Communicator.getDevice().then((result) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      if (result != 'error') {
        pref.setString('device', result);
      }
      
    });
  }

  textFieldWidget(String label, bool secure, TextEditingController controller){
    return Container(
        margin: EdgeInsets.all(20),
        child: TextField(
          obscureText: secure,
          controller: controller,
          style: new TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: label,
              hintStyle: TextStyle(color: Colors.white),
              contentPadding: EdgeInsets.all(15),
              filled: true,
              fillColor: Color(0x33ffffff),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0x33ffffff),
                    width: 1.0, ),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0x33ffffff), width: 1.0, ),
                borderRadius: BorderRadius.all(Radius.circular(10))
              )
          ),
        )
    );
  }

  requestPassword() {
    runApp(Password());

  }

  @override
  Widget build(BuildContext context) {

    SharedPreferences.getInstance().then((result) async {
      if (result.getString('token') != null) {

        
        Navigator.pushReplacementNamed(context, 'home');

        //runApp(Home());
      }
    });

    // TODO: implement build
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: ExactAssetImage('image/background.jpg'),
                fit: BoxFit.cover),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(image: ExactAssetImage('image/logo.png'), height: 60,),
                  textFieldWidget('Email', false, emailController),
                  textFieldWidget('Password', true, passwordController),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    child: FlatButton(onPressed: () {

                    Communicator.login(emailController.text, passwordController.text).then((result) async {

                      if (result == true){
                        SharedPreferences pre = await SharedPreferences.getInstance();
                        pre.setString('new', 'yes');
                        Navigator.pushReplacementNamed(context, 'home');
                      }

                    });
                    }, child: Text('Sign In'),
                      color: Colors.blueAccent, textColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 13,horizontal: 60),
                    ),
                  ), 
                  GestureDetector(
                    onTap: () => runApp(Password()),
                    child: Text("Request new password", style: TextStyle(color: Colors.white, fontSize: 15),),
                  )
                ],
              ),
            )
          ],
        ),
      );
  }

}