
import 'dart:convert';


import 'package:apglobalsystems/service/communicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ACC extends StatefulWidget {
  @override
  State<ACC> createState() => AccState();

}

class AccState extends State<ACC> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String quickStop, password, initAmount;
  String buttonValue = 'ON';
  double deviceNumber;
  var deviceData;
  TextEditingController speed = new TextEditingController();

  AccState() {
    getDevice();
  }

  getDevice() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var device = pref.getString('device');

    var _device = json.decode(device);
    print(_device['status']['accident']);

    String buttonCheck;

    if (_device['status']['accident'] == 'off' || _device['status']['accident'] == null) {
      buttonCheck = "ON";
    }else if(_device['status']['accident'] == 'on'){
      buttonCheck = "OFF";
    }

    setState(() {
      deviceNumber = _device['device'];
      quickStop = _device['status']['accident'];
      password = _device['password'];
      buttonValue = buttonCheck;
    });
  }

  activateSpeed() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var device = pref.getString('device');
    var _device = json.decode(device);

    print(_device['status']['accident']);

    setState(() {
      // brand = _device[0]['brand'] + " " + _device[0]['model'] + " " + _device[0]['year'];
      deviceNumber = _device['device'];
      quickStop = _device['status']['accident'];
      password = _device['password'];
      deviceData = _device;

    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
          appBar: AppBar(title: Text('ACC Alert'), centerTitle: true,),
          body: Container(
            margin: EdgeInsets.all(15),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("You will be notified whenever the car engine turns on or turns off "),

                RaisedButton(
                  child: Text(buttonValue, style: TextStyle(color: Colors.white),),
                  onPressed: () async {
                    await activateSpeed();

                    // Map<String, dynamic> status = Map<String, dynamic>();
                    //
                    // SharedPreferences pref = await SharedPreferences.getInstance();
                    // Map<String, dynamic> data = json.decode(pref.getString('user'));
                    //
                    // SmsQuery query = new SmsQuery();
                    // SmsSender sender = new SmsSender();
                    // String address = "${deviceNumber.toStringAsFixed(0)}";
                    // SmsMessage message;
                    //
                    // print(quickStop);
                    // print(address);
                    //
                    // if (quickStop == "off" || quickStop == null) {
                    //   message = new SmsMessage(address, 'ACC$password');
                    //
                    //   status['accident'] = 'on';
                    //   deviceData['status'] = status;
                    //
                    //   Communicator.updateStatus('accident', 'on', deviceNumber.toString(), data['id']);
                    //   setState(() {
                    //     buttonValue = 'ON';
                    //   });
                    //
                    //
                    // }else{
                    //   message = new SmsMessage(address, 'noACC$password');
                    //
                    //   deviceData['status']['accident'] = 'off';
                    //   Communicator.updateStatus('accident', 'off', deviceNumber.toString(), data['id']);
                    //   setState(() {
                    //     buttonValue = 'OFF';
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