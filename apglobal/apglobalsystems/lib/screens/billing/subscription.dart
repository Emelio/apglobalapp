import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Subscription extends StatefulWidget {
  State<Subscription> createState() => SubscriptionState();
}

class SubscriptionState extends State<Subscription> {

  buttons(String name, String amount, String stage ) {
    return  Container(
      width: 120,
      height: 80,
      child: RaisedButton(onPressed: () async {
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        pref.setString('subType', stage);
                        Navigator.pushNamed(context, 'paySub');
      }, child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('$name', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          Text('$amount', style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center,)
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('BILLING'), centerTitle: true,
       bottom: PreferredSize(child: Padding(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), child: Text('Choose to pay as you go or get unlimited access to the app', style: TextStyle(color: Colors.white, fontSize: 14), textAlign: TextAlign.center,),),
              preferredSize: Size.fromHeight(60.0))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: buttons('\$500', '70 Commands', 'P1'),),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: buttons('\$700', '110 Commands', 'P2'),
                      ),
                    
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                     Padding(
                      padding: EdgeInsets.all(10),
                      child: buttons('\$1000', '155 Commands', 'P3'),
                    ),
                    
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    Padding(
                      padding: EdgeInsets.all(10),
                      child: buttons('\$1,800', 'Unlimited for one months', 'U2'),
                    ),
                    
                  ],),


                
              ],
            ),
          ),
        ],
      ),
    );
  }

}