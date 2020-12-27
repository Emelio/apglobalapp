import 'package:apglobalsystems/service/communicator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController mobile = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _password;

  String _email;

  String _mobile;
  bool _autoValidate = false;



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

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
                        text: 'if you  have a account \n then ',
                        style: TextStyle(color: Color(0xFF84FFFA), fontSize: 20),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Login now',
                              style: TextStyle(
                                  color: Colors.blueAccent, fontSize: 20),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                      context, 'login');
                                })
                        ]),
                  ),
                ),
              ),

              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(children: <Widget>[
                    SizedBox(height: kToolbarHeight + 60),

                    Text(
                      "SIGN UP",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 40),
                    ),
                    EmailInput(),
                    PasswordInput(),
                    phoneInputForm(),


                    SizedBox(height: 20),
                    Container(
                      child: FlatButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            check().then((intenet) async {
                              if (intenet != null && intenet) {
                                AlertDialog alert = AlertDialog(
                                  content: new Row(
                                    children: [
                                      CircularProgressIndicator(),
                                      Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: Text("Sign up...",style: TextStyle(color: Colors.blueAccent),)),
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
                                if (await Communicator.register(
                                _email, _password, _mobile)) {
                              Navigator.pushNamed(context, 'home');
                              } else {
                              Navigator.pop(context);
                              FocusScope.of(context).requestFocus(FocusNode());

                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content:
                              Text('information does not match system'),
                              ));
                              }

                              }else{
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
                          'Sign up',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  /*  Text(
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
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        ),
                        Container(
                            child: Image.asset(
                              "image/instagram.png",
                              height: 40,
                              width: 40,
                            ),
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                        Container(
                            child: Image.asset(
                              "image/twitter.png",
                              height: 40,
                              width: 40,
                            ),
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                      ],
                    ),
                    SizedBox(height: height * .10),
                    Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.bottomCenter,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: 'if you have a account \n then ',
                            style: TextStyle(color: Color(0xFF84FFFA), fontSize: 20),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Login now',
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 20),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacementNamed(
                                          context, 'login');
                                    })
                            ]),
                      ),
                    ),*/
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget phoneInputForm() {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 18, 40, 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        maxLength: 15,
        validator: validateMobile,
        onSaved: (phone) => _mobile = phone,
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.fromLTRB(20,10, 10, 10),
              child: Image.asset(
                'image/phone.png',
                height: 5,
                width: 5,
              ),
            ),
            hintText: "Mobile Phone Number",
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
        textInputAction: TextInputAction.next,
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
      margin: EdgeInsets.fromLTRB(40, 35, 40, 10),
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

  String validPhone(String phone) {
    if (phone.isEmpty) {
      return 'Please enter phone number';
    } else if (phone.length < 10 || phone.length > 15) {
      return 'Please enter valid phone number';
    }
    return null;
  }


  String validateMobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    }
    else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }else if (value.length < 10 || value.length > 15) {
      return 'Please enter valid phone number';
    }
    return null;
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
