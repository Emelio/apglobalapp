
import 'package:apglobal/screens/billing/addcard.dart';
import 'package:apglobal/screens/billing/home.dart';
import 'package:apglobal/screens/billing/manage.dart';
import 'package:apglobal/screens/home.dart';
import 'package:apglobal/screens/map.dart';
import 'package:apglobal/screens/myapp.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  title: 'test',
  home: MyApp(),
  routes: <String, WidgetBuilder> {
    'login': (BuildContext context) => MyApp(),
    'home': (BuildContext context) => Home(),
    'billing': (BuildContext context) => BillingHome(),
    'managecard': (BuildContext context) => ManageCard(),
    'addCard': (BuildContext context) =>  AddCard(),
    'maps': (BuildContext context) => Maps()},
  theme: ThemeData(
    backgroundColor: Color(0xFF0081b0),
    primaryColor: Color(0xFF0081b0),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF0081b0)
    )
  ),
));


