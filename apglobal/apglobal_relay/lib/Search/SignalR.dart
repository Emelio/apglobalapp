import 'package:apglobal_relay/Shared/SMS.dart';
import 'package:flutter/material.dart';
import 'package:signalr_client/hub_connection_builder.dart';

class SignalR {

  final GlobalKey<ScaffoldState> scaffoldKey;

  SignalR({this.scaffoldKey});

  connect() async {

    final serverUrl = "https://api.apgloballimited.com/relayhubR";
    final hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
    hubConnection.onclose( (error) async {
      print("Connection Closed");

      Navigator.popAndPushNamed(scaffoldKey.currentContext, 'search');
    });
    await hubConnection.start();

    print('signalR');

    hubConnection.on("ReceiveMessage", _handleAClientProvidedFunction);
  }

  _handleAClientProvidedFunction(dynamic message) {

    print(message[0]);
    print("_handleAClientProvidedFunction");

    Sms(device: message[0]['device'], type: message[0]['task'], value: message[0]['value']).sendMessage();
  }


}