import 'dart:convert';

import 'package:apglobalsystems/service/communicator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'myapp.dart';
import 'newPassword.dart';

class Password extends StatefulWidget {
  PasswordState createState() => PasswordState();
}

class PasswordState extends State<Password> {
  String _email;
  TextEditingController email = new TextEditingController();
  TextEditingController code = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  Future<String> post;

  @override
  void initState() {
    super.initState();

  }
  Future<String> resetPassword(){
    post=Communicator.resetPassword(_email);
  }

  textFieldWidget(String label, bool secure, TextEditingController controller) {
    return Container(
        margin: EdgeInsets.all(20),
        child: TextField(
          obscureText: secure,
          controller: controller,
          style: new TextStyle(color: Colors.black),
          decoration: InputDecoration(
              hintText: label,
              hintStyle: TextStyle(color: Colors.black),
              contentPadding: EdgeInsets.all(15),
              filled: true,
              fillColor: Color(0x33ffffff),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
        ));
  }



  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: Stack(children: <Widget>[
            Container(
                decoration: BoxDecoration(
              image: DecorationImage(
                  image: ExactAssetImage('image/background_car.png'),
                  fit: BoxFit.cover),
            )),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                  autovalidate: _autoValidate,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: kToolbarHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap:(){
                            Navigator.pop(context);

              },
                          child: Container(
                            height: 30.0,
                            width: 30.0,
                            decoration: BoxDecoration(
                              color: Color(0xFF24438A),
                              borderRadius: BorderRadius.circular(1),
                              border: Border.all(color: Color(0xFF24438A)),
                            ),
                            margin: EdgeInsets.fromLTRB(30, 0, 0, 30),
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Image.asset(
                                'image/cancel.png',
                                height: 30,
                                width: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(50, 0, 0, 30),
                      width: double.infinity,
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 35),
                      ),
                    ),
                    Text(
                        "Please Enter you email address. You will \nrecieve a link to create a new password \nvia email",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15)),
                    EmailInput(),
SizedBox(height: 10,),
                    Container(


                      child: FlatButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();


                            check().then((intenet) {
                              if (intenet != null && intenet) {
                                AlertDialog alert = AlertDialog(
                                  content: new Row(
                                    children: [
                                      CircularProgressIndicator(),
                                      Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: Text("Reset Password...",style: TextStyle(color: Colors.blueAccent),)),
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

                                Communicator.resetPassword(_email).then((value) {
                                  Navigator.pop(context);
                                  FocusScope.of(context).requestFocus(FocusNode());

                                });
                              }else{
                                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please check internet connection"),));

                              }

                            });


                          //  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please check your email"),));

                         /*   FutureBuilder<String>(
                              future: resetPassword(),
                              builder: (context, snapshot){
                                if(snapshot.hasData){
                                  return CircularProgressIndicator();
                                }else if(snapshot.hasError){
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text("Please check your email")));
                                }else if(snapshot.hashCode==404){
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text("Please check your email")));
                                }
                                return CircularProgressIndicator();
                                 }
                               ,);*/
                          //  Communicator.resetPassword(_email);



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
                          'Send',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        color: Colors.blueAccent,
                        textColor: Colors.white,

                        padding: EdgeInsets.symmetric(horizontal: 30),
                      ),
                    ),
                  /*  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            print(email.text);
                            Communicator.resetPassword(email.text);

                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Please check your email"),
                            ));
                          },
                          child: Text("Reset Password"),
                        ),
                        RaisedButton(
                          onPressed: () {
                            showDialog(
                                context: _scaffoldKey.currentContext,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Verification Code"),
                                    content: textFieldWidget("Code", false, code),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("verify"),
                                        onPressed: () {
                                          Communicator.checkVerificationCode(
                                                  code.text)
                                              .then((result) {
                                            print(result);
                                            Map<String, dynamic> veri =
                                                json.decode(result);

                                            print(veri);
                                            if (veri['status'] == 'yes') {
                                              runApp(ResetPassword());
                                            } else {
                                              _scaffoldKey.currentState
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    "The code you entered is incorrect}"),
                                              ));
                                            }
                                          });
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("close"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text("I have a code"),
                        )
                      ],
                    )*/
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
  Widget EmailInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 45, 40, 20),
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
