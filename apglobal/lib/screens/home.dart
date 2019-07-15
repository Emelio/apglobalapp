
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';
import "dart:ui" as ui;

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoder/geocoder.dart';


import 'deviceList.dart';

class Home extends StatefulWidget {
  
  Homestate createState() => Homestate();
}

class Homestate extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String brand = 'Loading';
  double deviceNumber;
  String arm, monitor, powerString, power, password, deviceId = '';
  String carImage = "image/car_outline2.png"; 
  String place = 'Loading';
  

  Homestate(){

    getDevice(_scaffoldKey.currentContext);

    
    SharedPreferences.getInstance().then((result) async {

      var device = await Communicator.getDevice();
      var _device;

      if ( device != 'error') {
        _device = json.decode(device);
      }else{
         _device = json.decode(result.getString('device'));
      }

      
      

      try{
        _device = json.decode(device);
        print(_device);
      } on NoSuchMethodError {

        getNewData();

      }

      

      var image;
      var powerStringtemp;
      var placeHolder;

    setState(()  {
       
      

    var carState = _device['status']['arm'];
      
    if (carState == 'off') {
      image = 'image/car_outline2.png';
    }else if(carState == 'on') {
      image = 'image/car_outline.png';
    }

    if(_device['status']['power'] == 'on'){
      powerStringtemp = 'Kill switch activated';
    }else if(_device['status']['power'] == 'off'){
      powerStringtemp = 'Kill switch deactivated';
    }

    print(carState);

       brand = _device['brand'] + " " + _device['model'] + " " + _device['year']; 
       deviceNumber = _device['device'];
       arm = _device['status']['arm'];
      monitor = _device['status']['monitor'];
      powerString = powerStringtemp;
      power = _device['status']['power'];
      password = _device['password'];
      deviceId = _device['_id'];
      carImage = image;
      
    });

    });



    if(monitor == "on"){
      SmsSender sender = new SmsSender();
      String address = "${deviceNumber.toStringAsFixed(0)}";
      SmsMessage message = new SmsMessage(address, 'tracker123456');
      sender.sendSms(message);

      Communicator.updateStatus("monitor", "off", deviceId);

    }
  }

  getNewData() async {
    var device = await Communicator.getDevice();
    print(device);

    var _device = json.decode(device);

    setState(() {

      var image;
      var powerStringtemp;
      var placeHolder;

      var carState = _device['status']['arm'];

      if (carState == 'off') {
        image = 'image/car_outline2.png';
      }else if(carState == 'on') {
        image = 'image/car_outline.png';
      }

      if(_device['status']['power'] == 'on'){
        powerStringtemp = 'Kill switch activated';
      }else if(_device['status']['power'] == 'off'){
        powerStringtemp = 'Kill switch deactivated';
      }

      print(carState);

      brand = _device['brand'] + " " + _device['model'] + " " + _device['year'];
      deviceNumber = _device['device'];
      arm = _device['status']['arm'];
      monitor = _device['status']['monitor'];
      powerString = powerStringtemp;
      power = _device['status']['power'];
      password = _device['password'];
      deviceId = _device['_id'];
      carImage = image;


    });
    return device;
  }

  getDevice(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token'); 
    List<String> tokens = token.split('.');

    var carList = await Communicator.getDeviceList();
    await Communicator.getDevice();


     if(carList == 'login') {
       Navigator.pushNamed(context, 'login');
     }
     getTracking();



    
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

  getTracking(){
    Communicator.getTracking().then((result) async {



      SharedPreferences pref = await SharedPreferences.getInstance();

      try{
        var trackingLocalData = json.decode(pref.getString('tracking'));


          double catcheTime = trackingLocalData['Time'];
          double liveTime = result['time'];

          double lat;
          double longi ;

          if(catcheTime > liveTime){
            print(trackingLocalData);

           // lat = double.parse(trackingLocalData['Lat']);
           // longi = double.parse(trackingLocalData['Longi']);
          }else{
            print(result);

            lat = result['lat'];
            longi = result['longi'];
          }

          var placeHolder;

          if(lat != null){
            // From coordinates
            final coordinates = new Coordinates(lat, longi);
            var addresses = await Geocoder.google("AIzaSyD9QV-Hdz5bxRAiE1goVUiMsbHF039q_N0").findAddressesFromCoordinates(coordinates);;
            var first = addresses.first;
            placeHolder = first.addressLine;
            print(first.addressLine);
          }else{
            placeHolder = "no location data";
          }

          setState(() {
            place = placeHolder;
          });




      } catch(e){
        double lat = result['lat'];
        double longi = result['longi'];

        var placeHolder;

        if(lat != null){
          // From coordinates
          final coordinates = new Coordinates(lat, longi);
          var addresses = await Geocoder.google("AIzaSyD9QV-Hdz5bxRAiE1goVUiMsbHF039q_N0").findAddressesFromCoordinates(coordinates);
          var first = addresses.first;
          placeHolder = first.addressLine;
          print(first.addressLine);
        }else{
          placeHolder = "no location data";
        }

        setState(() {
          place = placeHolder;
        });
      }



    });
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
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Dashboard"), backgroundColor: Color(0xFF3a94bf), 
        actions: <Widget>[
          IconButton(
                      onPressed: (){
                        Navigator.popAndPushNamed(context, 'maps');
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
          
          runApp(DeviceList());
        },
      ),
      ListTile(
        title: Row(children: <Widget>[ Padding(padding: EdgeInsets.only(right: 15), child: Icon(Icons.attach_money),),Text('Billing')],),
        onTap: () => Navigator.popAndPushNamed(context, 'billing'),
      ),
      ListTile(
        title: Row(children: <Widget>[ Padding(padding: EdgeInsets.only(right: 15), child: Icon(Icons.add_alert),),Text('Alerts')],),
        onTap: () {
          
          Navigator.pushNamed(context, 'alertoptions');
        },
      ),
              ListTile(
                title: Row(children: <Widget>[ Padding(padding: EdgeInsets.only(right: 15), child: Icon(Icons.all_out),),Text('Car Care Coming Soon')],),
                onTap: () {

                },
              ),
      ListTile(
        title: Row(children: <Widget>[ Padding(padding: EdgeInsets.only(right: 15), child: Icon(Icons.security),),Text('Logout')],),
        onTap: () {
          SharedPreferences.getInstance().then((result) {
            result.remove('token');
            Navigator.pushNamedAndRemoveUntil(context, 'login', (Route<dynamic> route) => false);
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
                      Text('$place',style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),

                Container(
                  child: Image(image: ExactAssetImage(carImage), width: 200,),
                ),

                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('$powerString', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                ),

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
                                String address = "${deviceNumber.toStringAsFixed(0)}";
                                SmsMessage message; 
                                if (arm == "on") {
                                  message = new SmsMessage(address, 'disarm$password');
                                }else if(arm == "off"){
                                  message = new SmsMessage(address, 'arm$password');
                                }else{
                                  message = new SmsMessage(address, 'arm$password');
                                }
                                
                                message.onStateChanged.listen((state) {

                                  if (state == SmsMessageState.Sent) {
                                    print("SMS is sent!");
                                    Navigator.popAndPushNamed(context, 'loading');;
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
                                  String address = "${deviceNumber.toStringAsFixed(0)}";
                                  SmsMessage message;

                                  

                                  if (monitor == "off") {
                                    // send message to turn monitor on and iniate call
                                    message = new SmsMessage(address, 'monitor$password');

                                    message.onStateChanged.listen((state){


                                      if (state == SmsMessageState.Sent) {

                                        Communicator.updateStatus("monitor", "on", deviceId);
                                        
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
                                    message = new SmsMessage(address, 'tracker$password');
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
                                String address = "${deviceNumber.toStringAsFixed(0)}";
                                SmsMessage message; 
                                if (power == "on") {
                                  message = new SmsMessage(address, 'resume$password');
                                }else if(power == "off"){
                                  message = new SmsMessage(address, 'stop$password');
                                }else{
                                  message = new SmsMessage(address, 'stop$password');
                                }
                                
                                message.onStateChanged.listen((state) {

                                  if (state == SmsMessageState.Sent) {
                                    print("SMS is sent!");
                                    Navigator.popAndPushNamed(context, 'loading');
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
                              IconButton(icon: Icon(Icons.notification_important, color: Colors.white), onPressed: (){}, iconSize: 35,),
                              Padding(
                                padding: EdgeInsets.only(top: 25, right: 10),
                                child:IconButton(icon: Icon(Icons.my_location, color: Colors.white), iconSize: 35, onPressed: (){
                                  SmsSender sender = new SmsSender();
                                  String address = "${deviceNumber.toStringAsFixed(0)}";

                                  SmsMessage message = new SmsMessage(address, 'fix030s001n$password'); 

                                  message.onStateChanged.listen((state) {

                                  if (state == SmsMessageState.Sent) {
                                    print("SMS is sent!");
                                    Navigator.popAndPushNamed(context, 'loading');
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
      );
  }

}