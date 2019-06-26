
import 'dart:convert';

import 'package:apglobal/screens/alerts.dart';
import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';

import 'home.dart';
import 'map.dart';

class LoadingScreenExample extends StatefulWidget {
  @override
  LoadingScreenExampleState createState() => LoadingScreenExampleState();
}

class LoadingScreenExampleState extends State<LoadingScreenExample> {
  SmsReceiver receiver = new SmsReceiver();
  double devicePhone; 
  String deviceId; 
  Map<String, dynamic> deviceData;

  LoadingScreenExampleState() {
    getDevice();
    receiver.onSmsReceived.listen((SmsMessage msg){

      print(devicePhone.toStringAsFixed(0));
      print(msg.sender.substring(2));

      if (devicePhone.toStringAsFixed(0).contains(msg.sender.substring(2))) {

        print(msg.sender+" : "+ devicePhone.toStringAsFixed(0) );
        print(msg.body);
        print(msg.address);
        
        if (msg.body.contains('Tracker is activated')) {
          
          Communicator.updateStatus("arm", "on", deviceId);
          deviceData['status']['arm'] = "on";
          runApp(Home());

        }else if(msg.body.contains('Tracker is deactivated')){
          
          Communicator.updateStatus("arm", "off", deviceId);
          deviceData['status']['arm'] = "off";
          runApp(Home());
          
        }else if(msg.body.contains('lat')) {


          Map<String, dynamic> map = new Map(); 
          String message = msg.body;
          List<String> members = message.split("\n"); 

          for (var item in members) {
            List<String> cord = item.split(":");

            switch (cord[0]) {
              case 'lat':
                map['Lat'] = cord[1];
                break;

              case 'long':
                map['Longi'] = cord[1];
                break;

              case 'speed':
                map['Speed'] = cord[1];
                break;  
                
              default:
            }

          }

          map['Time'] = new DateTime.now().millisecondsSinceEpoch;

          print(map);

          Communicator.addTracking(map);

          runApp(Maps());
        }else if(msg.body.contains("speed OK!")){
          runApp(AlertOptions());
        }else if(msg.body.contains("Stop engine Succeed")){

          Communicator.updateStatus("power", "off", deviceId);
          deviceData['status']['power'] = "off";
          runApp(Home());

        }else if(msg.body.contains("Resume engine Succeed")) {

          Communicator.updateStatus("power", "on", deviceId);
          deviceData['status']['power'] = "on";
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
      deviceId = _device['_id'];
      deviceData = _device;
    });
  }

  updateBackground(Map<String, dynamic> map) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('device', json.encode(map));
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