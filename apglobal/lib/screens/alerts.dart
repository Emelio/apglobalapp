
import 'package:apglobal/screens/home.dart';
import 'package:flutter/material.dart';


class AlertOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar( title: Text('Alerts'), centerTitle: true, leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => runApp(Home()),),),
        body: GridView.count(
  primary: false,
  padding: const EdgeInsets.all(20.0),
  crossAxisSpacing: 10.0,
  crossAxisCount: 2,
  children: <Widget>[
    Container(
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

    Container(
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

    Container(
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


    Container(
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
          Text("Accident Alert", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
        ],
      ),
    ),
    
    Container(
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

    Container(
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
          Icon(Icons.battery_alert, size: 70, color: Colors.white,),
          Text("Low Battery Alert", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
        ],
      ),
    ),

  ],
),
      ),
    );
  }

}