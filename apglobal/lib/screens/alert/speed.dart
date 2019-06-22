
import 'package:apglobal/screens/alerts.dart';
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
        appBar: AppBar(title: Text('Alerts'), centerTitle: true, leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => runApp(AlertOptions()),)),
        body: Column(
          children: <Widget>[
            Text(""),
          ],
        ),
      ),
    );
  }

}