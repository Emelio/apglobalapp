
import 'package:apglobal_relay/Shared/Commands.dart';
import 'package:apglobal_relay/Shared/api.dart';
import 'package:flutter/material.dart';
import 'package:sms_maintained/sms.dart';

class Sms {
  final dynamic device;
  final String type;
  final String value;
  String trueValue;
  Sms({this.device, this.type, this.value});

  sendMessage() {
    SmsSender sender = new SmsSender();
    String stateData;

      String address = "${device['device']}";
      SmsMessage message;

      switch(type){
        case 'track':
          message = new SmsMessage(
              address, TK303.unlimitedTrack(device['device']['password'].toString()));
          stateData = "track";
          break;
        case 'killswitch':

          if(value == 'on'){
            message = new SmsMessage(address, TK303.StopEngine(device['device']['password'].toString()));
            trueValue = 'on';

          }else if(value == 'off'){
            message = new SmsMessage(address, TK303.StartEngine(device['device']['password'].toString()));
            trueValue = 'off';
          }
          stateData = "power";

          break;

        case 'arm':

          if(value == 'on'){
            message = new SmsMessage(address, TK303.arm(device['device']['password'].toString()));
            trueValue = 'on';

          }else if(value == 'off'){
            message = new SmsMessage(address, TK303.disarm(device['device']['password'].toString()));
            trueValue = 'off';
          }
          stateData = "arm";

          break;

        case 'monitor':

          if(value == 'on'){
            message = new SmsMessage(address, TK303.monitor(device['device']['password'].toString()));
            trueValue = 'on';

          }else if(value == 'off'){
            message = new SmsMessage(address, TK303.track(device['device']['password'].toString()));
            trueValue = 'off';
          }
          stateData = "monitor";

          break;
      }

      sender.sendSms(message);

      message.onStateChanged
          .listen((state) {
        if (state ==
            SmsMessageState.Sent) {
          print("SMS is sent!");

          if(stateData != "track"){
            ApiEndpoints.updateStatus(device['device']['device'], stateData, trueValue);
          }

        } else if (state ==
            SmsMessageState.Delivered) {
          print("SMS is delivered!");



        } else if (state ==
            SmsMessageState.Fail) {
          final snackBar = SnackBar(
            content: Text(
                'Unable to contact device, please ensure you have credit on the phone'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change!
              },
            ),
          );

          // Find the Scaffold in the Widget tree and use it to show a SnackBar!
        }
      });


  }
}