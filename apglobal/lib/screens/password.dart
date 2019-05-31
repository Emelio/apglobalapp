import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';

class Password extends StatefulWidget {

PasswordState createState() => PasswordState();
}

class PasswordState extends State<Password> {

  TextEditingController email = new TextEditingController();

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

  resetPassword() {
    
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text("Reset Password"), centerTitle: true, ),
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Text("Enter your email address on file"),
              ), 
              textFieldWidget("Email", false, email),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    onPressed: (){
                      print(email.text);
                      Communicator.resetPassword(email.text);

                      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please check your email"),));
                    },
                    child: Text("Reset Password"),
                  ),
                  RaisedButton(
                    onPressed: (){},
                    child: Text("I have a code"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}