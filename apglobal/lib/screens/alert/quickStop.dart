
import 'dart:convert';

import 'package:apglobal/screens/alerts.dart';
import 'package:apglobal/screens/loading.dart';
import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';

class QuickStop extends StatefulWidget {
  @override
  State<QuickStop> createState() => QuickStopState();

}

class QuickStopState extends State<QuickStop> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String quickStop, password, deviceId, initAmount;
  String buttonValue = 'ON';
  double deviceNumber;
  var deviceData;
  TextEditingController speed = new TextEditingController();

  QuickStopState() {
    getDevice();
  }

  getDevice() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token');
    List<String> tokens = token.split('.');

    var device = pref.getString('device');

    var _device = json.decode(device);
    print(_device['status']['quickStop']);

    String buttonCheck;

    if (_device['status']['quickStop'] == 'off') {
      buttonCheck = "ON";
    }else if(_device['status']['quickStop'] == 'on'){
      buttonCheck = "OFF";
    }

    setState(() {
      deviceNumber = _device['device'];
      quickStop = _device['status']['quickStop'];
      password = _device['password'];
      deviceId = _device['_id'];
      buttonValue = buttonCheck;
    });
  }

  activateSpeed() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var device = pref.getString('device');
    var _device = json.decode(device);

    print(_device['status']['quickStop']);

    setState(() {
      // brand = _device[0]['brand'] + " " + _device[0]['model'] + " " + _device[0]['year'];
      deviceNumber = _device['device'];
      quickStop = _device['status']['quickStop'];
      password = _device['password'];
      deviceId = _device['_id'];
      deviceData = _device;

    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('Quick Stop'), centerTitle: true, leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => runApp(AlertOptions()),)),
          body: Container(
            margin: EdgeInsets.all(15),
            child:  Column(
              children: <Widget>[
                Text("By default the kill switch command will shut the engine down after the speed has decreased to 20Km per hour. If this function is on, your car will shutdown immediately."),

                RaisedButton(
                  child: Text(buttonValue),
                  onPressed: () async {
                    await activateSpeed();

                    SharedPreferences pref = await SharedPreferences.getInstance();

                    SmsQuery query = new SmsQuery();
                    SmsSender sender = new SmsSender();
                    String address = "${deviceNumber.toStringAsFixed(0)}";
                    SmsMessage message;

                    print(quickStop);
                    print(address);

                    if (quickStop == "off") {
                      message = new SmsMessage(address, 'quickstop$password');

                      Communicator.updateStatus('quickStop', 'on', deviceId);
                      setState(() {
                        buttonValue = 'ON';
                      });


                    }else{
                      message = new SmsMessage(address, 'noquickstop$password');
                      Communicator.updateStatus('quickStop', 'off', deviceId);
                      setState(() {
                        buttonValue = 'OFF';
                      });
                    }

                    message.onStateChanged.listen((state) {

                      if (state == SmsMessageState.Sent) {
                        print("SMS is sent!");
                        runApp(LoadingScreenExample());
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
      ),
    );
  }

}