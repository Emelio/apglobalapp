
import 'package:flutter/material.dart';

class BillingHome extends StatefulWidget {
  State<BillingHome> createState() => BillingHomeState();
}

class BillingHomeState extends State<BillingHome> {

  buttons(String name) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: 120,
      height: 80,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        // Box decoration takes a gradient
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.blue[800],
            Colors.blue[600],
            Colors.blue[600],
            Colors.blue[800],
          ],
        ),
      ),
      child: Text('$name', style: TextStyle(color: Colors.white,), textAlign: TextAlign.center,),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text('Subscription Status', style: TextStyle(fontSize: 14),), centerTitle: true, elevation: 0,),
        body: Column(
          children: <Widget>[
            Container(
              color: Color(0xFF0081b0),
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(children: <Widget>[
                    Text('ACTIVE', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
                    Text('March 20, 2018 to March 12, 2018', style: TextStyle(color: Colors.white, fontSize: 12))
                  ],)
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(child: buttons("Manage Card"),
                    onTap: (){
                      Navigator.pushNamed(context, 'managecard');
                    },),
                    GestureDetector(child: buttons("Choose Subscription"), onTap: (){
                      Navigator.pushNamed(context, 'subscription');
                    },),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    buttons("Order Device (Coming soon)"),
                    buttons("Car Care (Coming soon)"),
                  ],
                )
              ],
            )
          ],
        )
      );
  }

}