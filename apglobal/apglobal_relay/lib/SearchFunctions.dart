
import 'dart:async';
import 'dart:convert';

import 'package:apglobal_relay/Shared/Commands.dart';
import 'package:sms_maintained/sms.dart';

class SearchFunctions {

  static SocketConnection() {

    //final channel = IOWebSocketChannel.connect('ws://echo.websocket.org');


//    int messageNum = 0;
//// Configure WebSocket url
//    final socket = WebsocketManager('wss://echo.websocket.org');
//// Listen to close message
//    socket.onClose((dynamic message) {
//      print('close');
//    });
//
//
//// Listen to server messages
//    socket.onMessage((dynamic message) {
//      print('recv: $message');
//      print(message.trim());
//      socket.connect();
//
//      if (messageNum == 10) {
//      socket.close();
//      } else {
//      messageNum += 1;
//      final String msg = '$messageNum: ${DateTime.now()}';
//      print('send: $msg');
//      socket.send(msg);
//      }
//
//      });
//// Connect to server
//    socket.connect();
  }

  static relay(Map<String, dynamic> operation){
    switch(operation['command']) {
      case 'track':

        String status = "";

        SmsSender sender = new SmsSender();
        SmsMessage message = new SmsMessage(operation['sim'], TK303.singleTrack(operation['duration'], operation['interval'], operation['password']));

        message.onStateChanged.listen((state) {
          if (state == SmsMessageState.Sent) {
            status = "SMS is sent!";
          } else if (state == SmsMessageState.Delivered) {
            status = "SMS is delivered!";
          }
        });
        sender.sendSms(message);
        return status;

        break;
    }
  }
}