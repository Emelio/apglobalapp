
import 'dart:convert';

import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';

class Movement extends StatefulWidget {
  @override
  State<Movement> createState() => MovementState();

}

class MovementState extends State<Movement> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String movement, password, deviceId, initAmount;
  String buttonValue = 'Activate';
  double deviceNumber;
  var deviceData;
  TextEditingController move = new TextEditingController();

  MovementState() {
    getDevice();
  }

  getDevice() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token');
    List<String> tokens = token.split('.');

    var device = pref.getString('device');

    var _device = json.decode(device);
    print(_device['status']['movement']);

    String buttonCheck;

    if (_device['status']['movement'] == 'off') {
      buttonCheck = "Activate";
    }else if(_device['status']['movement'] == 'on'){
      buttonCheck = "Deactivate";
    }

    setState(() {
      deviceNumber = _device['device'];
      movement = _device['status']['movement'];
      password = _device['password'];
      deviceId = _device['_id'];
      buttonValue = buttonCheck;
    });
  }

  activateSpeed() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var device = pref.getString('device');
    var _device = json.decode(device);

    print(_device['status']['movement']);

    setState(() {
      // brand = _device[0]['brand'] + " " + _device[0]['model'] + " " + _device[0]['year'];
      deviceNumber = _device['device'];
      movement = _device['status']['movement'];
      password = _device['password'];
      deviceId = _device['_id'];
      deviceData = _device;

    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
          appBar: AppBar(title: Text('Movement Alert'), centerTitle: true,),
          body: Container(
            margin: EdgeInsets.all(15),
            child:  Column(
              children: <Widget>[
                Text("When the vehicle stays immobile in a place for 3 - 10 minutes, this feature can be activated track the vehicle moves more than the expected distance."),
                Container(
                  width: 120,
                  padding: EdgeInsets.only(top: 10),
                  child: TextField(
                    obscureText: false,
                    controller: move,

                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'km',
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text(buttonValue),
                  onPressed: () async {
                    await activateSpeed();

                    SharedPreferences pref = await SharedPreferences.getInstance();

                    SmsQuery query = new SmsQuery();
                    SmsSender sender = new SmsSender();
                    String address = "${deviceNumber.toStringAsFixed(0)}";
                    SmsMessage message;

                    print(movement);
                    print(address);

                    if (movement == "off") {
                      message = new SmsMessage(address, 'move$password ${move.text}');
                      deviceData['status']['movement'] = 'on';
                      pref.setString('device', json.encode(deviceData));
                      Communicator.updateStatus('movement', 'on', deviceId);
                      setState(() {
                        buttonValue = 'Activate';
                      });


                    }else{
                      message = new SmsMessage(address, 'nomove$password');

                      deviceData['status']['movement'] = 'off';
                      pref.setString('device', json.encode(deviceData));
                      Communicator.updateStatus('movement', 'off', deviceId);
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