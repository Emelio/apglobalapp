import 'package:apglobalsystems/screens/password.dart';
import 'package:apglobalsystems/screens/register.dart';
import 'package:apglobalsystems/service/communicator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apglobalsystems/screens/home.dart';

import 'home.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;

  String _password;

  String _email;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  textFieldWidget(String label, bool secure, TextEditingController controller) {
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
                  borderSide: BorderSide(
                    color: Color(0x33ffffff),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x33ffffff),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
        ));
  }

  requestPassword() {
    runApp(Password());
  }

  @override
  void initState() {

    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);


    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ExactAssetImage('image/background_car.png'),
                      fit: BoxFit.cover),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.bottomCenter,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'if you not have a account \n then ',
                        style: TextStyle(color: Color(0xFF84FFFA), fontSize: 20),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Register now',
                              style: TextStyle(
                                  color: Colors.blueAccent, fontSize: 20),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                      context, 'register');
                                })
                        ]),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: kToolbarHeight + 60),
                      Text(
                        "SIGN IN",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 40),
                      ),
                      SizedBox(height: 10,),
                      EmailInput(),
                      PasswordInput(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          InkWell(

                            child: Container(
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF3AE15f)),
                              ),
                              margin: EdgeInsets.fromLTRB(40, 0, 50, 20),
                            ),
                            onTap: (){
                              Navigator.pushNamed(
                                  context, 'password');
                            },
                          )
                        ],
                      ),
                      Container(
                        child: FlatButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              print(_email);
                              print(_password);

                              check().then((intenet) {
                                if (intenet != null && intenet) {
                                  AlertDialog alert = AlertDialog(
                                    content: new Row(
                                      children: [
                                        CircularProgressIndicator(),
                                        Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Text("Sign in...",style: TextStyle(color: Colors.blueAccent),)),
                                      ],
                                    ),
                                  );
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    },
                                  );
                                  Communicator.login(_email, _password)
                                      .then((result) async {
                                    if (result == true) {
                                      SharedPreferences pre =
                                      await SharedPreferences.getInstance();
                                      pre.setString('new', 'yes');
                                      Navigator.pushReplacementNamed(context, 'home');
                                    } else {
                                      Navigator.pop(context);
                                      FocusScope.of(context).requestFocus(FocusNode());

                                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text(
                                            'Password or email address is incorrect'),
                                      ));
                                    }
                                  });
                                }
                                else{
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please check internet connection"),));

                                }
                              });

                            } else {
                              setState(() {
                                _autoValidate = true;
                              });
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0)),
                              side: BorderSide(color: Colors.blueAccent)),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 30),
                        ),
                      ),
         /*             Container(
                        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                        child: FlatButton(
                          onPressed: () {
                            Communicator.login(
                                    emailController.text, passwordController.text)
                                .then((result) async {
                              if (result == true) {
                                SharedPreferences pre =
                                    await SharedPreferences.getInstance();
                                pre.setString('new', 'yes');
                                Navigator.pushReplacementNamed(context, 'home');
                              } else {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      'Password or email address is incorrect'),
                                ));
                              }
                            });
                          },
                          child: Text('Sign In'),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          padding:
                              EdgeInsets.symmetric(vertical: 13, horizontal: 60),
                        ),
                      ),*/
                      /*   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => runApp(Password()),
                            child: Text(
                              "Request new password",
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          FlatButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, 'register'),
                            child: Text(
                              "Register User",
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ],
                      )*/
                      SizedBox(
                        height: 42,
                      ),
                     /* Text(
                        "OR",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Image.asset(
                              "image/google.png",
                              height: 40,
                              width: 40,
                            ),
                          ),
                          Container(
                            child: Image.asset(
                              "image/facebook.png",
                              height: 50,
                              width: 50,
                            ),
                            margin: EdgeInsets.fromLTRB(14, 0, 0, 0),
                          ),
                          Container(
                              child: Image.asset(
                                "image/instagram.png",
                                height: 40,
                                width: 40,
                              ),
                              margin: EdgeInsets.fromLTRB(14, 0, 0, 0)),
                          Container(
                              child: Image.asset(
                                "image/twitter.png",
                                height: 40,
                                width: 40,
                              ),
                              margin: EdgeInsets.fromLTRB(14, 0, 0, 0)),
                        ],
                      ),
                      SizedBox(height: height * .12),
                      Container(
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.bottomCenter,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: 'if you not have a account \n then ',
                              style: TextStyle(color: Color(0xFF84FFFA), fontSize: 20),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Register now',
                                    style: TextStyle(
                                        color: Colors.blueAccent, fontSize: 20),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                            context, 'register');
                                      })
                              ]),
                        ),
                      ),*/
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget EmailInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 50, 40, 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
          validator: (email) {
            if (email.length == 0) {
              return 'Email is Required"';
            } else if (!EmailValidator.validate(email)) {
              return 'Please enter valid email';
            }
            return null;
          },
          onSaved: (email) => _email = email,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: Image.asset(
                  'image/email.png',
                  height: 5,
                  width: 5,
                ),
              ),
              hintText: "Your Email",
              hintStyle: TextStyle(
                  color: Colors.black12,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              contentPadding: EdgeInsets.all(15),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x33ffffff),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x33ffffff),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30))))),
    );
  }

  Widget PasswordInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 30, 40, 5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        maxLength: 10,

        validator: (password) {
          if (password.isEmpty) {
            return 'Please enter password';
          } else if (password.length < 5) {
            return 'Please ente valid password';
          }
          return null;
        },
        onSaved: (password) => _password = password,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10, 10, 10),
              child: Image.asset(
                "image/password.png",
                height: 5,
                width: 5,
              ),
            ),
            hintText: "Password",
            hintStyle: TextStyle(
                color: Colors.black12,
                fontSize: 18,
                fontWeight: FontWeight.w600),
            contentPadding: EdgeInsets.all(15),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0x33ffffff),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0x33ffffff),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(30)))),
        textInputAction: TextInputAction.done,
      ),
    );
  }


  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

}
