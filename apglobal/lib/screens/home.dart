
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Homestate createState() => Homestate();
}

class Homestate extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: ExactAssetImage('image/background.jpg'),
                    fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      )
    );
  }

}