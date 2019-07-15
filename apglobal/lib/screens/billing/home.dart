
import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';

class BillingHome extends StatefulWidget {
  State<BillingHome> createState() => BillingHomeState();
}

class BillingHomeState extends State<BillingHome> {

  String subscriptionNote; 

  BillingHomeState() 
  {
    Communicator.subscription().then((result){
      if(result['Type'] == 'PayAsYouGo') {
        subscriptionNote = 'You have ${result['commands']} remaining';
      }else if(result['Type'] == 'Unlimited') {
        subscriptionNote = 'Expires on ${result['expirationDate']} remaining';
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
            return Navigator.pushNamed(context, 'subscription');
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