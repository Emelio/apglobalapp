import 'dart:async';
import 'dart:convert';

import 'package:apglobal_relay/Search/SignalR.dart';
import 'package:apglobal_relay/Shared/Models/Tracking.dart';
import 'package:apglobal_relay/Shared/SMS.dart';
import 'package:apglobal_relay/Shared/api.dart';
import 'package:flutter/material.dart';
import 'package:sms_maintained/sms.dart';
import 'package:wakelock/wakelock.dart';

import '../SearchFunctions.dart';

class Search extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => SearchState();

}




class SearchState extends State<Search> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SearchState() {
    SignalR(scaffoldKey: _scaffoldKey).connect();
    init();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Wakelock.enable();

    SmsReceiver receiver = new SmsReceiver();
    receiver.onSmsReceived.listen((SmsMessage msg) async {

      if (msg.body.toLowerCase().contains('lat')) {
        Tracking track = new Tracking();

        String message = msg.body;
        List<String> members = message.split("\n");

        for (var item in members) {
          List<String> cord = item.split(":");

          switch (cord[0]) {
            case 'lat':
              track.latitude= double.parse(cord[1]);
              break;

            case 'long':
              track.longitude = double.parse(cord[1]);
              break;

            case 'speed':
              track.speed = double.parse(cord[1]);
              break;

            default:
          }

        }

        track.device = msg.sender.substring(2);
        await ApiEndpoints.tracking(track.toJson());
      }else if(msg.body.toLowerCase().contains("stop engine succeed")){
        ApiEndpoints.updateStatus(msg.sender.substring(2), 'power', 'on');
      }else if(msg.body.toLowerCase().contains("resume engine succeed")){
        ApiEndpoints.updateStatus(msg.sender.substring(2), 'power', 'off');
      }


    });
  }

  init() async {

    List<dynamic> data = await ApiEndpoints.all();

    await track();

  }

  track() async{
    List<dynamic> data = await ApiEndpoints.all();

    int index = 0;

    Timer.periodic(Duration(seconds: 3), (timer) {
      if(index == data.length){
        timer.cancel();
      }else{
        Sms(device: data[index], type: 'track').sendMessage();

      }
      index++;
      print(index);
      print(data.length);
      print('track');

    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Search'),),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

          ],
        ),
      ),

    );
  }

}