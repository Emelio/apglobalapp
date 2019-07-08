
import 'dart:convert';

import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';

class LoadingScreenExample extends StatefulWidget {
  @override
  LoadingScreenExampleState createState() => LoadingScreenExampleState();
}

class LoadingScreenExampleState extends State<LoadingScreenExample> {
  SmsReceiver receiver = new SmsReceiver();
  double devicePhone; 
  String deviceId; 
  Map<String, dynamic> deviceData;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  LoadingScreenExampleState() {
    getDevice();
    receiver.onSmsReceived.listen((SmsMessage msg) async {


      SharedPreferences pref = await SharedPreferences.getInstance();

      if (devicePhone.toStringAsFixed(0).contains(msg.sender.substring(2))) {


        String bodyData = msg.body.toLowerCase();
        
        
        if (bodyData.contains('tracker is activated')) {
          
          Communicator.updateStatus("arm", "on", deviceId);
          deviceData['status']['arm'] = "on";
          // change data to string and save it 

          updateBackground(deviceData);
          Navigator.popAndPushNamed(context, 'home');

        }else if(bodyData.contains('tracker is deactivated')){
          
          Communicator.updateStatus("arm", "off", deviceId);
          deviceData['status']['arm'] = "off";

          updateBackground(deviceData);

          Navigator.popAndPushNamed(context, 'home');
          
        }else if(bodyData.contains('lat')) {

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

          var now = new DateTime.now();
          map['Time'] = now.millisecondsSinceEpoch.toDouble();

          String trackingData = json.encode(map);

          pref.setString('tracking', trackingData);

          print(map);

          Communicator.addTracking(map);

          Navigator.popAndPushNamed(context, 'maps');

        }else if(bodyData.contains("speed ok!") || bodyData.contains("quickstop OK") || bodyData.contains("noquickstop OK") || bodyData.contains("move OK")){
          Navigator.pop(context);
        }else if(bodyData.contains("stop engine succeed")){

          Communicator.updateStatus("power", "on", deviceId);
          deviceData['status']['power'] = "on";
          updateBackground(deviceData);
          Navigator.popAndPushNamed(context, 'home');

        }else if(bodyData.contains("resume engine succeed")) {

          Communicator.updateStatus("power", "off", deviceId);
          deviceData['status']['power'] = "off";
          updateBackground(deviceData);
          Navigator.popAndPushNamed(context, 'home');
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
    return Scaffold(
      key: _scaffoldKey,
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
      );
  }
  
}