
import 'dart:convert';

import 'package:apglobalsystems/service/communicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Movement extends StatefulWidget {
  @override
  State<Movement> createState() => MovementState();

}

class MovementState extends State<Movement> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String movement, password, initAmount;
  String buttonValue = 'Activate';
  double deviceNumber;
  var deviceData;
  TextEditingController move = new TextEditingController();

  MovementState() {
    getDevice();
  }

  getDevice() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var device = pref.getString('device');

    var _device = json.decode(device);
    print(_device['status']['movement']);

    String buttonCheck;

    if (_device['status']['movement'] == 'off' || _device['status']['movement'] == null) {
      buttonCheck = "Activate";
    }else if(_device['status']['movement'] == 'on'){
      buttonCheck = "Deactivate";
    }

    setState(() {
      deviceNumber = _device['device'];
      movement = _device['status']['movement'];
      password = _device['password'];
      buttonValue = buttonCheck;
      deviceData = _device;
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
                  child: Text(buttonValue, style: TextStyle(color: Colors.white),),
                  onPressed: () async {
                    await activateSpeed();

                    // SharedPreferences pref = await SharedPreferences.getInstance();
                    // Map<String, dynamic> data = json.decode(pref.getString('user'));
                    //
                    // SmsQuery query = new SmsQuery();
                    // SmsSender sender = new SmsSender();
                    // String address = "${deviceNumber.toStringAsFixed(0)}";
                    // SmsMessage message;
                    //
                    // print(movement);
                    // print(address);
                    //
                    // if (movement == "off" || movement == null) {
                    //   message = new SmsMessage(address, 'move$password ${move.text}');
                    //   deviceData['status']['movement'] = 'on';
                    //   Communicator.updateStatus('movement', 'on', deviceNumber.toString(), data['id']);
                    //   setState(() {
                    //     buttonValue = 'Activate';
                    //   });
                    //
                    //
                    // }else{
                    //   message = new SmsMessage(address, 'nomove$password');
                    //
                    //   deviceData['status']['movement'] = 'off';
                    //   Communicator.updateStatus('movement', 'off', deviceNumber.toString(), data['id']);
                    //   setState(() {
                    //     buttonValue = 'Deactivate';
                    //   });
                    // }
                    //
                    // message.onStateChanged.listen((state) {
                    //
                    //   if (state == SmsMessageState.Sent) {
                    //     print("SMS is sent!");
                    //     Navigator.popAndPushNamed(context, 'loading', arguments: deviceData);
                    //   } else if (state == SmsMessageState.Delivered) {
                    //     print("SMS is delivered!");
                    //   }else if(state == SmsMessageState.Fail){
                    //     final snackBar = SnackBar(
                    //       content: Text('Unable to contact device, please ensure you have credit on the phone'),
                    //       action: SnackBarAction(
                    //         label: 'Undo',
                    //         onPressed: () {
                    //           // Some code to undo the change!
                    //         },
                    //       ),
                    //     );
                    //
                    //     // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                    //     _scaffoldKey.currentState.showSnackBar(snackBar);
                    //   }
                    // });
                    // sender.sendSms(message);
                  },
                )
              ],
            ),
          )
      );
  }

}