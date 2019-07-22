
import 'dart:convert';

import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';

class Speed extends StatefulWidget {
  @override
  State<Speed> createState() => SpeedState();

}

class SpeedState extends State<Speed> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String overspeed, password, deviceId, initAmount; 
  String buttonValue = 'Activate';
  double deviceNumber;
  var deviceData;
  TextEditingController speed = new TextEditingController();

  SpeedState() {
    getDevice();
  }

  getDevice() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token'); 
    List<String> tokens = token.split('.');

    var device = pref.getString('device');
    var amount = pref.getString('overSpeedAmount');

    var _device = json.decode(device);
    print(_device['status']['overspeed']);

    String buttonCheck; 

    if (_device['status']['overspeed'] == 'off') {
      buttonCheck = "Activate";
    }else if(_device['status']['overspeed'] == 'on'){
      buttonCheck = "Deactivate";
    }

    if (amount == null) {
      amount = "0";
    }

    setState(() {
      deviceNumber = _device['device'];
      overspeed = _device['status']['overspeed'];
      password = _device['password'];
      deviceId = _device['_id'];
      buttonValue = buttonCheck;
      initAmount = amount; 
    });
  }

  activateSpeed(String speed) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var device = pref.getString('device');
    var _device = json.decode(device);

    _device['status']['overspeed'] = speed;

    var newData = json.encode(_device);
    pref.setString('device', newData);

    setState(() {
      // brand = _device[0]['brand'] + " " + _device[0]['model'] + " " + _device[0]['year'];
      deviceNumber = _device['device'];
      overspeed = _device['status']['overspeed'];
      password = _device['password'];
      deviceId = _device['_id'];
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
                    labelText: '$initAmount km/h',
                  ),
                ),
              ), 
              RaisedButton(
                child: Text(buttonValue),
                onPressed: () async {


                  SharedPreferences pref = await SharedPreferences.getInstance();
                  
                  SmsQuery query = new SmsQuery();
                  SmsSender sender = new SmsSender();
                  String address = "${deviceNumber.toStringAsFixed(0)}";
                  SmsMessage message;

                  if (overspeed == "off") {
                    await activateSpeed('on');
                    message = new SmsMessage(address, 'speed$password ${speed.text}');
                    pref.setString('overSpeedAmount', speed.text);
                    Communicator.updateStatus('speed', 'on', deviceId); 
                    setState(() {
                      buttonValue = 'Activate';
                    });

                    
                  }else{
                    await activateSpeed('off');
                    message = new SmsMessage(address, 'nospeed$password');
                    Communicator.updateStatus('speed', 'off', deviceId);
                    setState(() {
                      buttonValue = 'Deactivate';
                    });
                  }

                  message.onStateChanged.listen((state) {

                                  if (state == SmsMessageState.Sent) {
                                    print("SMS is sent!");
                                    Navigator.popAndPushNamed(context, 'loading');
                                  } else if (state == SmsMessageState.Delivered) {
                                    print("SMS is delivered!");
                                  }else if(state == SmsMessageState.Fail){
                                    final snackBar = SnackBar(
                                      content: Text('Unable to contact device, please ensure you have credit on the phone'),
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () {
                                          // Some code to undo the change!
                                        },
                                      ),
                                    );

                                    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                                    _scaffoldKey.currentState.showSnackBar(snackBar);
                                  }
                                });
                                sender.sendSms(message);
                },
              )
            ],
          ),
        )
      );
  }

}