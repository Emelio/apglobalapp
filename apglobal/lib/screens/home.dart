
import 'dart:convert';

import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';
import "dart:ui" as ui;

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  
  Homestate createState() => Homestate();
}

class Homestate extends State<Home> {

  Homestate(){

    getDevice();
  }

  getDevice() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token'); 
    List<String> tokens = token.split('.');
    Map<String, dynamic> map = json.decode(decodeBase64(tokens[1])); 
    String userId = map['nameid']; 

    var device = await Communicator.getDevice(userId);
    print(userId);

    setState(() {
      
    });
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
                      onPressed: (){

                      },
                      icon: Icon(Icons.more_vert, color: Colors.white,),
                    ),
                    Text('Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                    IconButton(
                      onPressed: (){

                      },
                      icon: Icon(Icons.map, color: Colors.white,),
                    )

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
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: ExactAssetImage('image/background2.png'),
                    fit: BoxFit.cover),
              ),
            ),
            Column(
              children: <Widget>[
                heading(),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 50, horizontal: 0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        child: Text('Toyota Probox 2012', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
                      ),
                      Text('now at:', style: TextStyle(color: Colors.white)),
                      Text('no data',style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 80, vertical: 40),
                  child: Image(image: ExactAssetImage('image/car_outline.png'), height: 180,),
                ),

                Expanded(
                  child: Stack( 
                  children: <Widget>[
                    Positioned(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.all(0),
                          height: 150,
                          width: 600,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: ExactAssetImage('image/controls.png'),
                                fit: BoxFit.contain),
                          ),
                        ),
                      ),
                    ),

                    Positioned(child: Align( alignment: FractionalOffset.bottomCenter, 
                    child: Container(
                      height: 150,
                      width: 350,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              
                              IconButton(icon: Icon(Icons.lock_outline, color: Colors.white,), iconSize: 35, onPressed: (){},),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: IconButton(icon: Icon(Icons.speaker, color: Colors.white), iconSize: 35, onPressed: (){},),
                              ),
                            ],
                          ),
                          Column( 
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                            IconButton(icon: Icon(Icons.power_settings_new,  color: Colors.white), onPressed: (){}, iconSize: 105,)
                          ],),
                          Column(
                            children: <Widget>[
                              IconButton(icon: Icon(Icons.tram, color: Colors.white), onPressed: (){}, iconSize: 35,),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
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