
import 'package:apglobal/screens/alert/acc.dart';
import 'package:apglobal/screens/alert/movement.dart';
import 'package:apglobal/screens/alert/power.dart';
import 'package:apglobal/screens/alert/quickStop.dart';
import 'package:apglobal/screens/alert/speed.dart';
import 'package:apglobal/screens/alerts.dart';
import 'package:apglobal/screens/billing/addcard.dart';
import 'package:apglobal/screens/billing/home.dart';
import 'package:apglobal/screens/billing/manage.dart';
import 'package:apglobal/screens/billing/payment.dart';
import 'package:apglobal/screens/billing/subscription.dart';
import 'package:apglobal/screens/home.dart';
import 'package:apglobal/screens/loading.dart';
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
    'subscription': (BuildContext context) => Subscription(),
    'payment': (BuildContext context) => Payment(),
    'managecard': (BuildContext context) => ManageCard(),
    'addCard': (BuildContext context) =>  AddCard(),
    'maps': (BuildContext context) => Maps(),
    'alertoptions': (BuildContext context) => AlertOptions(),
    'loading': (BuildContext context) =>  LoadingScreenExample(),

    'speed': (BuildContext context) => Speed(),
    'quickStop': (BuildContext context) => QuickStop(),
    'movement': (BuildContext context) => Movement(),
    'acc': (BuildContext context) => ACC(),
    'power': (BuildContext context) => Power(),

    
  },
  theme: ThemeData(
    backgroundColor: Color(0xFF0081b0),
    primaryColor: Color(0xFF0081b0),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF0081b0)
    )
  ),
));


