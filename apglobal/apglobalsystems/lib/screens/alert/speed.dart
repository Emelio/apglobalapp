
import 'dart:convert';

import 'package:apglobalsystems/Model/User.dart';
import 'package:apglobalsystems/service/communicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Speed extends StatefulWidget {
  @override
  State<Speed> createState() => SpeedState();

}

class SpeedState extends State<Speed> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String overspeed, password, initAmount;
  String buttonValue = 'Activate';
  int deviceNumber, deviceId;
  var deviceData;
  TextEditingController speed = new TextEditingController();

  SpeedState() {
    getDevice();
  }

  getDevice() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    User device = User.fromJson(json.decode(pref.getString('device')));

    print(device.devices.first.status.overspeed);

    String buttonCheck;

    if(device.devices.first.status.overspeed == null){
      buttonCheck = "Activate";
    }else if (device.devices.first.status.overspeed == 'off') {
      buttonCheck = "Activate";
      device.devices.first.status.overspeed = "on";
      pref.setString("userData", json.encode(device));
    }else if(device.devices.first.status.overspeed == 'on'){
      buttonCheck = "Deactivate";
      device.devices.first.status.overspeed = "off";
      pref.setString("userData", json.encode(device));
    }



    setState(() {
      //deviceNumber = device.devices.first.device;
      overspeed = device.devices.first.status.overspeed;
      password =  device.devices.first.password.toString();
      //deviceId = device.devices.first.device;
      buttonValue = buttonCheck;
    });
  }

  activateSpeed(String speed) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var device = pref.getString('device');
    var _device = json.decode(device);

    _device['status']['overspeed'] = speed;

    var newData = json.encode(_device);

    setState(() {
      // brand = _device[0]['brand'] + " " + _device[0]['model'] + " " + _device[0]['year'];
      deviceNumber = _device['device'];
      overspeed = _device['status']['overspeed'];
      password = _device['password'];
      deviceId = _device['device'];
      deviceData = _device;

    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text('Over Speed Alert'), centerTitle: true, ),
        body: Container(
          margin: EdgeInsets.all(15),
          child:  Column(
            children: <Widget>[
              Text("When activated, the device will notify you when the car has exceed the speed limit that is set"),
              Padding(
                padding: EdgeInsets.only(top: 32),
                child: Text("Please set the speed limit"), 
              ), 
              Container(
                width: 120,
                padding: EdgeInsets.only(top: 10),
                child: TextField(
                  obscureText: false,
                  controller: speed,
                  
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ' km/h',
                  ),
                ),
              ), 
              RaisedButton(
                child: Text(buttonValue, style: TextStyle(color: Colors.white),),
                onPressed: () async {

                  //
                  // SharedPreferences pref = await SharedPreferences.getInstance();
                  //
                  // SmsQuery query = new SmsQuery();
                  // SmsSender sender = new SmsSender();
                  // String address = "${deviceNumber.toStringAsFixed(0)}";
                  // SmsMessage message;
                  //
                  // Map<String, dynamic> data = json.decode(pref.getString('user'));
                  //
                  // if(overspeed == null){
                  //   await activateSpeed('on');
                  //   message = new SmsMessage(address, 'speed$password ${speed.text}');
                  //   pref.setString('overSpeedAmount', speed.text);
                  //   Communicator.updateStatus('speed', 'on', deviceId.toString(), data['id']);
                  //   setState(() {
                  //     buttonValue = 'Activate';
                  //   });
                  // }else if(overspeed == 'on'){
                  //   await activateSpeed('off');
                  //   message = new SmsMessage(address, 'nospeed$password');
                  //   Communicator.updateStatus('speed', 'off', deviceId.toString(), data['id']);
                  //   setState(() {
                  //     buttonValue = 'Deactivate';
                  //   });
                  // }else if(overspeed == "off"){
                  //   await activateSpeed('on');
                  //   message = new SmsMessage(address, 'speed$password ${speed.text}');
                  //   pref.setString('overSpeedAmount', speed.text);
                  //   Communicator.updateStatus('speed', 'on', deviceId.toString(), data['id']);
                  //   setState(() {
                  //     buttonValue = 'Activate';
                  //   });
                  // }
                  //
                  //
                  // message.onStateChanged.listen((state) {
                  //
                  //                 if (state == SmsMessageState.Sent) {
                  //                   print("SMS is sent!");
                  //                   Navigator.popAndPushNamed(context, 'loading', arguments: deviceData);
                  //                 } else if (state == SmsMessageState.Delivered) {
                  //                   print("SMS is delivered!");
                  //                 }else if(state == SmsMessageState.Fail){
                  //                   final snackBar = SnackBar(
                  //                     content: Text('Unable to contact device, please ensure you have credit on the phone'),
                  //                     action: SnackBarAction(
                  //                       label: 'Undo',
                  //                       onPressed: () {
                  //                         // Some code to undo the change!
                  //                       },
                  //                     ),
                  //                   );
                  //
                  //                   // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                  //                   _scaffoldKey.currentState.showSnackBar(snackBar);
                  //                 }
                  //               });
                  //               sender.sendSms(message);
                },
              )
            ],
          ),
        )
      );
  }

}