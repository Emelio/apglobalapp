import 'package:apglobal_relay/Search/Search.dart';
import 'package:flutter/material.dart';


void main() {

  runApp(MaterialApp(
    title: 'Home',
    home: Search(),
    routes: {
      'search': (context) => Search()
    },
  ));
}


