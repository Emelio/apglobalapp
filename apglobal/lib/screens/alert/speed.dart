
import 'package:flutter/material.dart';

class Speed extends StatefulWidget {
  @override
  State<Speed> createState() => SpeedState();
}

class SpeedState extends State<Speed> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Over Speed Alert"),),
        body: Column(
          children: <Widget>[
            Text(""),
          ],
        ),
      ),
    );
  }

}