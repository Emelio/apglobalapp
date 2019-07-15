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
                      child: buttons('\$2500', '300 Commands', 'P1'),),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: buttons('\$5000', '600 Commands', 'P2'),
                      ),
                    
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                     Padding(
                      padding: EdgeInsets.all(10),
                      child: buttons('\$7500', '900 Commands', 'P3'),
                    ),
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        pref.setString('subType', 'P4');
                        Navigator.pushNamed(context, 'paySub');
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: buttons('\$10,000', '1200 Commands', 'P4'),
                      ),
                    ),
                    
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                     Padding(
                          padding: EdgeInsets.all(10),
                          child: buttons('\$1,500', 'Unlimited for one month', 'U1'),
                        ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: buttons('\$4,500', 'Unlimited for three months', 'U2'),
                    ),
                    
                  ],),

                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                     Padding(
                          padding: EdgeInsets.all(10),
                          child: buttons('\$9,000', 'Unlimited for six months', 'U3'),
                        ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: buttons('\$13,500', 'Unlimited for nine months', 'U4'),
                    ),
                    
                  ],)
                
              ],
            ),
          ),
        ],
      ),
    );
  }

}