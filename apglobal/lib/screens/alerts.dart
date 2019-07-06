
import 'package:apglobal/screens/alert/acc.dart';
import 'package:apglobal/screens/alert/movement.dart';
import 'package:apglobal/screens/alert/power.dart';
import 'package:apglobal/screens/home.dart';
import 'package:flutter/material.dart';

import 'alert/quickStop.dart';
import 'alert/speed.dart';


class AlertOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar( title: Text('Alerts'), centerTitle: true,),
        body: GridView.count(
  primary: false,
  padding: const EdgeInsets.all(20.0),
  crossAxisSpacing: 10.0,
  crossAxisCount: 2,
  children: <Widget>[
    GestureDetector(
      onTap: ()=> Navigator.pushNamed(context, 'speed'),
      child: Container(
        decoration: BoxDecoration(
          border: null,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.green,
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.event_available, size: 70, color: Colors.white,),
            Text("Over Speed Alart", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
          ],
        ),
      ),
        ),

    GestureDetector(
      onTap: ()=> Navigator.pushNamed(context, 'quickStop'),
    child: Container(
      decoration: BoxDecoration(
      border: null,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: Colors.green,
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),

      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
      Icon(Icons.stop, size: 70, color: Colors.white,),
      Text("Quick Stop Setting", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
      ],
      ),
      ),
      ),

    GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'movement'),
      child: Container(
        decoration: BoxDecoration(
          border: null,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.green,
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.input, size: 70, color: Colors.white,),
            Text("Movement Alert", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
          ],
        ),
      ),
    ),


    GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'acc'),
      child: Container(
        decoration: BoxDecoration(
          border: null,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.green,
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.vpn_key, size: 70, color: Colors.white,),
            Text("ACC Alert", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
          ],
        ),
      ),
    ),
    
    GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'power'),
      child: Container(
        decoration: BoxDecoration(
          border: null,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.green,
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.fullscreen, size: 70, color: Colors.white,),
            Text("Power Alert", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
          ],
        ),
      ),
    ),



  ],
),
    );
  }

}