
import 'dart:convert';

import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';

import 'home.dart';

class LoadingScreenExample extends StatefulWidget {
  @override
  LoadingScreenExampleState createState() => LoadingScreenExampleState();
}

class LoadingScreenExampleState extends State<LoadingScreenExample> {
  SmsReceiver receiver = new SmsReceiver();
  double devicePhone; 

  LoadingScreenExampleState() {
    getDevice();
    receiver.onSmsReceived.listen((SmsMessage msg){

      if (devicePhone.toString().contains(msg.sender)) {
        
        if (msg.body.contains('Tracker is activated')) {
          
          Communicator.updateStatus("arm", "on");
          runApp(Home());

        }else if(msg.body.contains('Tracker is deactivated')){
          
          Communicator.updateStatus("arm", "off");
          runApp(Home());
          
        }
        
      }else{
        print(msg.sender);
      }
      
    });
  }

  getDevice() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var device = pref.getString('device');

    var _device = json.decode(device);

    setState(() {

      devicePhone = _device['device'];

    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'Loading Screen Example',
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: ExactAssetImage('image/background2.png'),
                    fit: BoxFit.cover),
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Waiting for Device", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
                  Loading(indicator: BallPulseIndicator(), size: 100.0)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
}