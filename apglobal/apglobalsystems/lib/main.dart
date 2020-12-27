

import 'package:apglobalsystems/screens/fleet/home.dart';

import 'screens/password.dart';
import 'screens/splash.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'screens/alert/acc.dart';
import 'screens/alert/movement.dart';
import 'screens/alert/power.dart';
import 'screens/alert/quickStop.dart';
import 'screens/alert/speed.dart';
import 'screens/alerts.dart';
import 'screens/billing/addcard.dart';
import 'screens/billing/home.dart';
import 'screens/billing/manage.dart';
import 'screens/billing/payment.dart';
import 'screens/billing/paysub.dart';
import 'screens/billing/subscription.dart';
import 'screens/fleet/deviceList.dart';
import 'screens/home.dart';
import 'screens/loading.dart';
import 'screens/map.dart';
import 'screens/myapp.dart';
import 'screens/register.dart';
import 'package:flutter/material.dart';

void main(){
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(

      MaterialApp(
        debugShowCheckedModeBanner: false,

        title: 'test',
        home: SplashScreen(),
        routes: <String, WidgetBuilder> {
          'splash':(BuildContext context)=>SplashScreen(),
          'login': (BuildContext context) => MyApp(),
          'home': (BuildContext context) => Home(),
          'billing': (BuildContext context) => BillingHome(),
          'subscription': (BuildContext context) => Subscription(),
          'password':(BuildContext context)=>Password(),
          'payment': (BuildContext context) => Payment(),
          'paySub': (BuildContext context) => PaySub(),
          'managecard': (BuildContext context) => ManageCard(),
          'addCard': (BuildContext context) =>  AddCard(),
          'maps': (BuildContext context) => Maps(),
          'alertoptions': (BuildContext context) => AlertOptions(),
          // 'loading': (BuildContext context) =>  LoadingScreenExample(),
          'register': (BuildContext context) => Register(),

          'viewDevice': (BuildContext context) => FleetHome(),

          'speed': (BuildContext context) => Speed(),
          'quickStop': (BuildContext context) => QuickStop(),
          'movement': (BuildContext context) => Movement(),
          'acc': (BuildContext context) => ACC(),
          'power': (BuildContext context) => Power(),
          'switch': (BuildContext context) => DeviceList()


        },
        theme: ThemeData(
            backgroundColor: Color(0xFF0081b0),
            primaryColor: Color(0xFF0081b0),
            buttonTheme: ButtonThemeData(
                buttonColor: Color(0xFF0081b0)
            )
        ),
      ));

}


