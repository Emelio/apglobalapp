
import 'dart:convert';

import 'package:apglobal/screens/loading.dart';
import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';
import "dart:ui" as ui;

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';
import 'package:url_launcher/url_launcher.dart';

import 'myapp.dart';

class Home extends StatefulWidget {
  
  Homestate createState() => Homestate();
}

class Homestate extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String brand; 
  double deviceNumber = 123;
  String arm, monitor, power; 
  

  Homestate(){

    getDevice();

    if(monitor == "on"){
      SmsSender sender = new SmsSender();
      String address = "$deviceNumber";
      SmsMessage message = new SmsMessage(address, 'tracker123456');
      sender.sendSms(message);

      Communicator.updateStatus("monitor", "off");

    }
  }


  getDevice() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token'); 
    List<String> tokens = token.split('.');
    Map<String, dynamic> map = json.decode(decodeBase64(tokens[1])); 
    String userId = map['nameid']; 
    
    await Communicator.getDevice(userId);

    var device = pref.getString('device');
    var _device = json.decode(device);
    var monitorCheck;


    setState(() {
       brand = _device['brand'] + " " + _device['model'] + " " + _device['year']; 
       deviceNumber = _device['device'];
       arm = _device['status']['arm'];
      monitor = _device['status']['monitor'];
      power = _device['status']['power']; 
    });
  }

  _launchURL() async {
    var url = 'tel:'+ deviceNumber.toStringAsFixed(0);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  decodeBase64(String base) {
    
    var bytes = base64.decode(base);
    var base64Str = utf8.decode(bytes);
    return base64Str;
  }

  Widget armStatus(String arm) {

    if (arm == 'on') {
      
      return Container(
                  child: Image(image: ExactAssetImage('image/car_outline.png'), width: 200,),
                );
    }else{
      return Container(
                  child: Image(image: ExactAssetImage('image/car_outline2.png'), width: 200,),
                );
    }
  }

  heading() {
    return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: (){

                      },
                      icon: Icon(Icons.more_vert, color: Colors.white,),
                    ),
                    Text('Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                    

                  ],
                );
  }

  @override
  Widget build(BuildContext context) {

    Size s = ui.window.physicalSize/ui.window.devicePixelRatio;
    bool landscape = s.width<s.height;

    if (landscape) {
      SystemChrome.setEnabledSystemUIOverlays([]);
    }


    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Dashboard"), backgroundColor: Color(0xFF3a94bf), actions: <Widget>[
          IconButton(
                      onPressed: (){

                      },
                      icon: Icon(Icons.map, color: Colors.white,),
                    )
        ],),
        drawer: SizedBox(
          width: s.width * 0.65,
          child:  Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
        child: Text('Drawer Header'),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
      ListTile(
        title: Row(children: <Widget>[ Padding(padding: EdgeInsets.only(right: 15), child: Icon(Icons.devices),),Text('Switch Device')],),
        onTap: () {
          SharedPreferences.getInstance().then((result) {
            result.remove('token');
            runApp(MyApp());
          });
        },
      ),
      ListTile(
        title: Row(children: <Widget>[ Padding(padding: EdgeInsets.only(right: 15), child: Icon(Icons.security),),Text('Logout')],),
        onTap: () {
          SharedPreferences.getInstance().then((result) {
            result.remove('token');
            runApp(MyApp());
          });
        },
      ),
            ],
          ),
        ),
        ),
        key: _scaffoldKey, 
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: ExactAssetImage('image/background2.png'),
                    fit: BoxFit.cover),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 50, horizontal: 0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        child: Text('$brand', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
                      ),
                      Text('Last recorded location:', style: TextStyle(color: Colors.white)),
                      Text('no data',style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),

                armStatus(arm),

                Expanded(
                  child: Stack( 
                  children: <Widget>[
                    Positioned(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.all(0),
                          height: 170,
                          width: 400,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: ExactAssetImage('image/controls.png'),
                                fit: BoxFit.contain),
                          ),
                        ),
                      ),
                    ),

                    Positioned(child: Align( alignment: FractionalOffset.bottomCenter, 
                    child: Container(
                      height: 170,
                      width: 380,
                      padding: EdgeInsets.only(left: 25, right: 25, top: 23),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              
                              IconButton(icon: Icon(Icons.lock_outline, color: Colors.white,), iconSize: 35, onPressed: (){
                                SmsQuery query = new SmsQuery();
                                SmsSender sender = new SmsSender();
                                String address = "$deviceNumber";
                                SmsMessage message; 
                                if (arm == "on") {
                                  message = new SmsMessage(address, 'arm123456');
                                }else if(arm == "off"){
                                  message = new SmsMessage(address, 'disarm123456'); 
                                }else{
                                  message = new SmsMessage(address, 'disarm123456'); 
                                }
                                
                                message.onStateChanged.listen((state) {

                                  if (state == SmsMessageState.Sent) {
                                    print("SMS is sent!");
                                    runApp(LoadingScreenExample());
                                  } else if (state == SmsMessageState.Delivered) {
                                    print("SMS is delivered!");
                                  }else if(state == SmsMessageState.Fail){
                                    final snackBar = SnackBar(
                                      content: Text('Unable to contact device, please ensure you have credit on the phone'),
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () {
                                          // Some code to undo the change!
                                        },
                                      ),
                                    );

                                    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                                    _scaffoldKey.currentState.showSnackBar(snackBar);
                                  }
                                });
                                sender.sendSms(message);
    
                              },),
                              Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: IconButton(icon: Icon(Icons.speaker, color: Colors.white), iconSize: 35, onPressed: (){
                                  SmsQuery query = new SmsQuery();
                                  SmsSender sender = new SmsSender();
                                  String address = "$deviceNumber";
                                  SmsMessage message;

                                  

                                  if (monitor == "off") {
                                    // send message to turn monitor on and iniate call
                                    message = new SmsMessage(address, 'monitor123456');

                                    message.onStateChanged.listen((state){


                                      if (state == SmsMessageState.Sent) {

                                        Communicator.updateStatus("monitor", "on");
                                        
                                        _launchURL();

                                      }else if(state == SmsMessageState.Fail){
                                         final snackBar = SnackBar(
                                          content: Text('Unable to contact device, please ensure you have credit on the phone'),
                                          action: SnackBarAction(
                                            label: 'Undo',
                                            onPressed: () {
                                              // Some code to undo the change!
                                            },
                                          ),
                                        );

                                        // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                                        _scaffoldKey.currentState.showSnackBar(snackBar);
                                      }
                                      
                                      });   

                                      sender.sendSms(message);                         

                                  }else{
                                    // turn off monitor  
                                    message = new SmsMessage(address, 'tracker123456');
                                  }


                                },),
                              ),
                            ],
                          ),
                          Column( 
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                            IconButton(icon: Icon(Icons.power_settings_new,  color: Colors.white), onPressed: (){
                              SmsQuery query = new SmsQuery();
                                SmsSender sender = new SmsSender();
                                String address = "$deviceNumber";
                                SmsMessage message; 
                                if (power == "on") {
                                  message = new SmsMessage(address, 'arm123456');
                                }else if(arm == "off"){
                                  message = new SmsMessage(address, 'disarm123456'); 
                                }else{
                                  message = new SmsMessage(address, 'disarm123456'); 
                                }
                                
                                message.onStateChanged.listen((state) {

                                  if (state == SmsMessageState.Sent) {
                                    print("SMS is sent!");
                                    runApp(LoadingScreenExample());
                                  } else if (state == SmsMessageState.Delivered) {
                                    print("SMS is delivered!");
                                  }else if(state == SmsMessageState.Fail){
                                    final snackBar = SnackBar(
                                      content: Text('Unable to contact device, please ensure you have credit on the phone'),
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () {
                                          // Some code to undo the change!
                                        },
                                      ),
                                    );

                                    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                                    _scaffoldKey.currentState.showSnackBar(snackBar);
                                  }
                                });
                                sender.sendSms(message);
                            }, iconSize: 115,)
                          ],),
                          Column(
                            children: <Widget>[
                              IconButton(icon: Icon(Icons.tram, color: Colors.white), onPressed: (){}, iconSize: 35,),
                              Padding(
                                padding: EdgeInsets.only(top: 35, right: 15),
                                child: Text('1hr', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),), )
                    
                    

                  ],
                ),
                )              ],
            )
          ],
        ),
      )
    );
  }

}