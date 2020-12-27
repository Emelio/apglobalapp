import 'package:apglobalsystems/service/communicator.dart';
import 'package:apglobalsystems/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import "dart:ui" as ui;

import 'package:shared_preferences/shared_preferences.dart';

class DrawerScreen extends StatefulWidget{

  bool drawer;
  Function(bool) callback;

  DrawerScreen(this.drawer, this.callback);
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool drawerState=false;
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF034872), //or set color with: Color(0xFF0000FF)
    ));

    Size s = ui.window.physicalSize / ui.window.devicePixelRatio;
    return  Container(
        height: s.height * 0.72,
        width: s.width * 0.63,
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(140)),
          child: Drawer(


            elevation: 5,


            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFF2037A9),
                  border: Border.all(
                      width: 3,
                      color: Color(0xFF2037A9),
                      style: BorderStyle.solid)),
              child: ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Image.asset(
                              "image/switch.png",
                              height: 20,
                              width: 20,
                            ),
                          ),
                          Text(
                            'Switch Device',
                            style:
                            TextStyle(color: Colors.white, fontSize: 15),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, 'switch');
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Image.asset(
                              "image/bill.png",
                              height: 20,
                              width: 20,
                            ),
                          ),
                          Text(
                            'Billing',
                            style:
                            TextStyle(color: Colors.white, fontSize: 15),
                          )
                        ],
                      ),
                      onTap: () =>
                          Navigator.popAndPushNamed(context, 'billing'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Image.asset(
                              "image/alarm.png",
                              height: 20,
                              width: 20,
                            ),
                          ),
                          Text(
                            'Alerts',
                            style:
                            TextStyle(color: Colors.white, fontSize: 15),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, 'alertoptions');
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Image.asset(
                              "image/car.png",
                              height: 20,
                              width: 20,
                            ),
                          ),
                          Text(
                            'Car Care Coming Soon',
                            style:
                            TextStyle(color: Colors.white, fontSize: 15),
                          )
                        ],
                      ),
                      onTap: () {},
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Image.asset(
                              "image/logout.png",
                              height: 20,
                              width: 20,
                            ),
                          ),
                          Text(
                            'Logout',
                            style:
                            TextStyle(color: Colors.white, fontSize: 15),
                          )
                        ],
                      ),
                      onTap: () {
                        SharedPreferences.getInstance().then((result) {
                          result.remove('token');
                          Navigator.pushNamedAndRemoveUntil(context, 'login',
                                  (Route<dynamic> route) => false);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );


  }

  @override
  void dispose() {

      widget.callback(false);
      print("closeeee");
super.dispose();

  }
}
