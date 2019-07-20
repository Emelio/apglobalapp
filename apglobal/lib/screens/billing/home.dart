
import 'dart:convert';

import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillingHome extends StatefulWidget {
  State<BillingHome> createState() => BillingHomeState();
}

class BillingHomeState extends State<BillingHome> {

  String subscriptionNote = '';


  BillingHomeState() {
    Communicator.getSubscription().then((result){
      print(result['type']);
      var subscriptionNot;
      if(result['type'] == 'PayAsYouGo') {
        print(result['Type']);
        subscriptionNot = 'Commands remaining: ${result['commands']}';
      }else if(result['Type'] == 'Unlimited') {
        subscriptionNot = 'Expires on ${result['expirationDate']}';
      }

      setState(() {
        subscriptionNote = subscriptionNot;

      });

    });
  }

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    SharedPreferences.getInstance().then((result){
      try{
        Map<String, dynamic> sub = json.decode(result.getString('subs'));

        if(sub['type'] == 'PayAsYouGo'){
          subscriptionNote = 'Commands remaining: ${sub['commands']}';
        }else{
          subscriptionNote = 'Expires on ${sub['expirationDate']}';
        }

      } catch(e) {
//        Navigator.pushNamedAndRemoveUntil(context, 'billing', (Route<dynamic> route) => false);
      }
    });
  }

  

  buttons(String name, String section) {

    return Container(
      width: 120,
      height: 60,
      child: RaisedButton(onPressed: () {
        switch(section){
          case 'manage':
            Navigator.pushNamed(context, 'managecard');
            break;

          case 'subscription':
            Navigator.pushNamed(context, 'subscription');
            break;

          default:
        }
      }, child: Text('$name', style: TextStyle(color: Colors.white,), textAlign: TextAlign.center,)),
    );

  }

  buttons2(String name, String section) {

    return Container(
      width: 120,
      height: 60,
      child: RaisedButton( child: Text('$name', style: TextStyle(color: Colors.white,), textAlign: TextAlign.center,)),
    );

  }

  @override
  Widget build(BuildContext context) {


    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text('BILLING', style: TextStyle(fontSize: 22),), centerTitle: true,
        bottom: PreferredSize(child: Padding(padding: EdgeInsets.symmetric(vertical: 10), child:
        Column(children: <Widget>[
        Text('Subscription Status', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
          Text('$subscriptionNote', style: TextStyle(color: Colors.white, fontSize: 14))
          ],),),
            preferredSize: Size.fromHeight(60.0)),),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(child: buttons("Manage Card", 'manage'),
                onTap: (){
                  Navigator.pushNamed(context, 'managecard');
                },),
              GestureDetector(child: buttons("Choose Subscription", 'subscription'), onTap: (){
                Navigator.pushNamed(context, 'subscription');
              },),
            ],
          ),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  buttons2("Order Device ", 'manage'),
                  buttons2("Car Care", ''),
                ],
              )
            ],
          ),
        )
      );
  }

}