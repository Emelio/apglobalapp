import 'dart:async';
import 'dart:ui';
import 'package:apglobalsystems/Model/User.dart';
import 'package:apglobalsystems/service/SignalR.dart';
import 'package:apglobalsystems/utils/Functions.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart' as l;
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

import 'package:apglobalsystems/service/communicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "dart:ui" as ui;

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'drawerScreen.dart';

class Home extends StatefulWidget {
  Homestate createState() => Homestate();
}

class Homestate extends State<Home> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController<Map<String, dynamic>> controller =
      StreamController<Map<String, dynamic>>();

  String brand = 'Loading';
  int deviceNumber = 0;
  String arm, monitor, power;
  int password = 0;
  int deviceId;
  Color powerColor = Colors.white;
  String home = 'image/home.png';
  String place = 'no data available';
  Devices deviceData = Devices();
  int drawerOpen = 0;
  bool drawerState = false;
  Communicator coms = Communicator();
  bool firstCall = false;
  bool powerCheck = false;
  bool armCheck = false;

  bool alertDial = false;

  Homestate() {
    checkSub();
  }

  @override
  void initState() {
    super.initState();

    SignalR(scaffoldKey: _scaffoldKey, stream: controller).connect();

    WidgetsBinding.instance.addObserver(this);


  }

  init() async {

    SharedPreferences pre = await SharedPreferences.getInstance();
    
    var user = json.decode(pre.getString('userData'));


    controller.stream.listen((event) async {


      print("SignalR");
      print(event);

      if(user['id'] == event['user']){
        switch (event['action']) {
          case 'power':
            
            bool check;
            if (event['value'] == "on") {
              check = true;
            } else {
              check = false;
            }

            setState(() {
              powerCheck = check;
              deviceData.status.power = event['value'];
            });

            if(alertDial){
              Future.delayed(Duration(seconds: 9), () {
                Navigator.pop(context);
              });
              this.alertDial = false;
            }

            break;

          case 'arm':
            
            bool check;
            if (event['value'] == "on") {
              check = true;
            } else {
              check = false;
            }


            setState(() {
              armCheck = check;
              deviceData.status.arm = event['value'];
            });
            if(alertDial){
              Navigator.pop(context);
              this.alertDial = false;
            }
            break;

          case 'monitor':
            bool check;
            if (event['value'] == "on") {
              check = true;
            } else {
              check = false;
            }


            setState(() {
              deviceData.status.monitor = event['value'];
            });
            break;
        }
      }


      //SignalR(scaffoldKey: _scaffoldKey, stream: controller).connect();
    });

    var carList = await this.coms.getDevices();

    var list = await this.coms.getTrackingData(carList[0]['device']['device']);

    var address;
    if(list != null) {
      address = await Functions.getAddressFromLocation(
          list['latitude'], list['longitude']);
    }else{
      address = "no address";
    }

    if(Devices.fromJson(carList[0]['device']).status.monitor == 'on'){
      Communicator.monitor(deviceData.device, "off");
    }

    setState(() {
      place = address;
      deviceData = Devices.fromJson(carList[0]['device']);
      powerCheck = deviceData.status.power == 'on' ? true : false;
      armCheck = deviceData.status.arm == 'on' ? true : false;
      brand =
          "${carList[0]['device']['make']} ${carList[0]['device']['model']} ${carList[0]['device']['year']}";
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.resumed) {
      SignalR(scaffoldKey: _scaffoldKey, stream: controller).connect();
      Communicator.monitor(deviceData.device, "off");
    }
    print('didChangeAppLifecycleState');
    //setState(() { _notification = state; });
  }

  Future<void> _showMyDialog() async {
    alertDial = true;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Device Executing Command'),
          content: Container(
            height: 200,
            child: Loading(
                indicator: BallPulseIndicator(),
                size: 20.0,
                color: Colors.green),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    controller.close();
  }

  getNewData() async {}

  checkSub() async {
    var subs = await Communicator.getSubscription();

    // check live server
    if (subs['type'] == 'PayAsYouGo') {
      if (subs['commands'] < 1) {
        Navigator.pushNamedAndRemoveUntil(
            context, 'billing', (Route<dynamic> route) => false);
      }
    } else if (subs['type'] == 'Unlimited') {
      var time = DateTime.parse(subs['expirationDate']).millisecondsSinceEpoch;
      var now = DateTime.now().millisecondsSinceEpoch;

      if (now > time) {
        Navigator.pushNamedAndRemoveUntil(
            context, 'billing', (Route<dynamic> route) => false);
      }
    } else if (subs == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, 'billing', (Route<dynamic> route) => false);
    }

    // check local
    try {
      if (subs['type'] == 'PayAsYouGo') {
        if (subs['commands'] < 0) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'billing', (Route<dynamic> route) => false);
        }
      } else {
        var time =
            DateTime.parse(subs['expirationDate']).millisecondsSinceEpoch;
        var now = DateTime.now().millisecondsSinceEpoch;

        if (now > time) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'billing', (Route<dynamic> route) => false);
        }
      }
    } catch (e) {
      Navigator.pushNamedAndRemoveUntil(
          context, 'billing', (Route<dynamic> route) => false);
    }
  }

  _launchURL(String urlData) async {
    var url = 'tel:+1' + urlData;
    print(url);
    print('_launchURL');
    await l.launch(url);

  }

  decodeBase64(String base) {
    var bytes = base64.decode(base);
    var base64Str = utf8.decode(bytes);
    return base64Str;
  }

  heading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ),
        Text(
          'Dashboard',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }

  void drawerFunc() {
    _scaffoldKey.currentState.openDrawer();
    if (_scaffoldKey.currentState.isDrawerOpen) {
      setState(() {
        drawerState = true;
      });
    }
  }

  callback(bool newAbc) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        drawerState = newAbc;
      });
      print("hiiii" + newAbc.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!firstCall) {
      init();
      firstCall = true;
    }

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF034872), //or set color with: Color(0xFF0000FF)
    ));
    // FlutterStatusbarcolor.setStatusBarColor( Color(0xFF034872));

    Size s = ui.window.physicalSize / ui.window.devicePixelRatio;
    bool landscape = s.width < s.height;

    if (landscape) {
      // SystemChrome.setEnabledSystemUIOverlays([]);
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawerEdgeDragWidth: 0,
        key: _scaffoldKey,
        drawer: DrawerScreen(true, callback),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage(home), fit: BoxFit.cover),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'image/dashboard.png',
                height: MediaQuery.of(context).size.height / 6.6,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 50, 10, 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: drawerFunc,
                    child: drawerState
                        ? Container(
                      margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                      child: Image.asset(
                        'image/cancel.png',
                        height: 20,
                        width: 20,
                      ),
                    )
                        : Image.asset(
                      'image/drawer.png',
                      height: 30,
                      width: 30,
                    ),
                  )),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'maps');
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    'image/search.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 45, 10, 20),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text("Dashboard",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 30))),
            ),
            Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(
                    0, MediaQuery.of(context).size.height / 5, 0, 0),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '$brand',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                              text: 'Last recorded location:\n',
                              style: TextStyle(color: Colors.white),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '$place',
                                    style: TextStyle(color: Colors.white))
                              ]),
                        ),
                      ),
                    ])),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Stack(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  powerCheck
                                      ? "Kill Switch Activated"
                                      : "Kill Switch Deactivated",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(" || ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  armCheck
                                      ? "Armed"
                                      : "Disarmed",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),

                              ],
                            ),
                            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          padding: EdgeInsets.all(0),
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width - 10,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: ExactAssetImage('image/control.png'),
                                fit: BoxFit.contain),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Container(
                            height: 170,
                            width: MediaQuery.of(context).size.width - 10,
                            padding:
                            EdgeInsets.only(left: 5, right: 25, top: 0),
                            child: FractionallySizedBox(
                              widthFactor: .8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        child: Opacity(
                                          opacity: 0.0,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.lock_outline,
                                              color: Colors.white,
                                            ),
                                            iconSize: 55,
                                            onPressed: () async {

                                              _showMyDialog();
                                              this.alertDial = true;

                                              if (deviceData.status.arm == "on") {
                                                Communicator.arm(
                                                    deviceData.device, "off");
                                              } else if (deviceData.status.arm == "off") {
                                                Communicator.arm(
                                                    deviceData.device, "on");
                                              } else {
                                                Communicator.arm(
                                                    deviceData.device, "on");
                                              }



                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 30),
                                        child: Opacity(
                                          opacity: 0.0,
                                          child: IconButton(
                                            icon: Icon(Icons.speaker,
                                                color: Colors.white),
                                            iconSize: 35,
                                            onPressed: () async {

                                              Communicator.monitor(
                                                  deviceData.device, "on");

                                              _launchURL(deviceData.device);

                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Opacity(
                                        opacity: 0.0,
                                        child: IconButton(
                                          icon: Icon(Icons.power_settings_new,
                                              color: Colors.green),
                                          onPressed: () async {
                                            if (deviceData.status.power == "off") {
                                              Communicator.killswitch(
                                                  deviceData.device, "on");
                                            } else if (deviceData.status.power == "on") {
                                              Communicator.killswitch(
                                                  deviceData.device, "off");
                                            } else {
                                              Communicator.killswitch(
                                                  deviceData.device, "off");
                                            }

                                            _showMyDialog();
                                            this.alertDial = true;
                                          },
                                          iconSize: 115,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Opacity(
                                          opacity: 0.0,
                                          child: IconButton(
                                            icon: Icon(
                                                Icons.notification_important,
                                                color: Colors.white),
                                            onPressed: () {},
                                            iconSize: 35,
                                          )),
                                      Padding(
                                        padding:
                                        EdgeInsets.only(top: 25, right: 10),
                                        child: Opacity(
                                          opacity: 0.0,
                                          child: IconButton(
                                            icon: Icon(Icons.my_location,
                                                color: Colors.white),
                                            iconSize: 35,
                                            onPressed: () {
                                              // Communicator.track(deviceNumber.toStringAsFixed(0));

                                              print('my_location');
                                              print(deviceData.device);

                                              Navigator.pushNamed(context, 'maps', arguments: deviceData.device);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
