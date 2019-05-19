

import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/background.jpg"),
              fit: BoxFit.cover
            )
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Username',
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                  ),
                  obscureText: true,
                ),                  
              ],
            ),
          )
        ),
      ),
    );
  }

}