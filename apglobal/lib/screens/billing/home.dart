
import 'package:flutter/material.dart';

class BillingHome extends StatefulWidget {
  State<BillingHome> createState() => BillingHomeState();
}

class BillingHomeState extends State<BillingHome> {

  buttons(String name) {

    return Container(
      width: 120,
      child: RaisedButton(onPressed: (){}, child: Text('$name', style: TextStyle(color: Colors.white,), textAlign: TextAlign.center,),),
    );
//    return Container(
//      margin: EdgeInsets.symmetric(vertical: 20),
//      width: 120,
//      height: 80,
//      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//      decoration: BoxDecoration(
//        // Box decoration takes a gradient
//        gradient: LinearGradient(
//          // Where the linear gradient begins and ends
//          begin: Alignment.topRight,
//          end: Alignment.bottomLeft,
//          // Add one stop for each color. Stops should increase from 0 to 1
//          stops: [0.1, 0.5, 0.7, 0.9],
//          colors: [
//            // Colors are easy thanks to Flutter's Colors class.
//            Colors.blue[800],
//            Colors.blue[600],
//            Colors.blue[600],
//            Colors.blue[800],
//          ],
//        ),
//      ),
//      child: Text('$name', style: TextStyle(color: Colors.white,), textAlign: TextAlign.center,),
//    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text('BILLING', style: TextStyle(fontSize: 20),), centerTitle: true, backgroundColor: Color(0xFF15DED0),
        bottom: PreferredSize(child: Padding(padding: EdgeInsets.symmetric(vertical: 10), child:
        Column(children: <Widget>[
        Text('Subscription Status', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
          Text('Expires March 12, 2018', style: TextStyle(color: Colors.white, fontSize: 12))
          ],),),
            preferredSize: Size.fromHeight(30.0)),),
        body: Column(
          children: <Widget>[

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
                    buttons("Order Device "),
                    buttons("Car Care"),
                  ],
                )
              ],
            )
          ],
        )
      );
  }

}