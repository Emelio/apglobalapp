
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:signalr_client/hub_connection_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignalR {

  final GlobalKey<ScaffoldState> scaffoldKey;
  final StreamController<Map<String, dynamic>> stream;

  SignalR({this.scaffoldKey, this.stream});

  connect() async {

    final serverUrl = "https://api.apgloballimited.com/relayhubR";
    final hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
    hubConnection.onclose( (error) async {
      print("Connection Closed");
      final serverUrl = "https://api.apgloballimited.com/relayhubR";
      final hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
      await hubConnection.start();
    });
    await hubConnection.start();

    print('signalR');

    hubConnection.on("ReplyMessage", _handleAClientProvidedFunction);
  }

  _handleAClientProvidedFunction( message) async {

    SharedPreferences pref = await SharedPreferences.getInstance();

    var user = json.decode(pref.getString("userData"));

    print(user);
    if(user['id'] == message[0]['user']) {

      Map<String, dynamic> data = message[0];

      stream.add(data);
    }




  }



}