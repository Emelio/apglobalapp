
import 'package:apglobalsystems/service/communicator.dart';
import 'package:flutter/material.dart';

import 'myapp.dart';

class ResetPassword extends StatelessWidget {


  TextEditingController password = new TextEditingController();


  textFieldWidget(String label, bool secure, TextEditingController controller){
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
                borderSide: BorderSide(color: Colors.blue,
                    width: 1.0, ),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0, ),
                borderRadius: BorderRadius.all(Radius.circular(10))
              )
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Reset Password'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10),
                child: Text("Enter your new password"),
              ), 
              textFieldWidget("New Password", true, password),
              RaisedButton(
                child: Text("Update"),
                onPressed: (){
                  Communicator.updatePassword(password.text).then((result) {
                    if (result['isAcknowledged'] == true) {
                      runApp(MyApp());
                    }
                  });
                },
              )
          ],
        ),
      ),
    ),
    );
  }


}