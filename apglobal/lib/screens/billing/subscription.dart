import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Subscription extends StatefulWidget {
  State<Subscription> createState() => SubscriptionState();
}

class SubscriptionState extends State<Subscription> {

  buttons(String name, String amount ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: 120,
      height: 80,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.all(Radius.circular(10.0)),
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
      child: Column(
        children: <Widget>[
          Text('$amount JMD', style: TextStyle(color: Colors.white, fontSize: 15)),
          Padding(
            padding: EdgeInsets.only(top: 7),
            child: Text('$name', style: TextStyle(color: Colors.white, fontSize: 9),),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Subscriptions'),),
      body: Column(
        children: <Widget>[
          Container(
            
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text('Pay As You Go', style: TextStyle(fontSize: 21),),
                ), 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        pref.setString('subType', 'P1');
                        Navigator.pushNamed(context, 'paySub');
                      },
                      child: Padding(
                      padding: EdgeInsets.all(10),
                      child: buttons('300 Commands', '\$2500'),
                    ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        pref.setString('subType', 'P2');
                        Navigator.pushNamed(context, 'paySub');
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: buttons('600 Commands', '\$4900'),
                      ),
                    ),
                    
                  ],
                )
              ],
            ),
          ),
          Container(
            
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text('Unlimited', style: TextStyle(fontSize: 21),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () async {
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          pref.setString('subType', 'U1');
                          Navigator.pushNamed(context, 'paySub');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: buttons('Per Month', '\$1,500'),
                        ),
                      ),
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences pref = await SharedPreferences.getInstance();
                          pref.setString('subType', 'U2');
                          Navigator.pushNamed(context, 'paySub');
                      },
                      child: Padding(
                      padding: EdgeInsets.all(10),
                      child: buttons('Per Year', '\$16,000'),
                    ),
                    ),
                    
                  ],
                ) 
              ],
            ),
          ),
        ],
      ),
    );
  }

}