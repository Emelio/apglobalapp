//
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:apglobalsystems/Model/Tracking.dart';
// import 'package:apglobalsystems/Model/User.dart';
// import 'package:apglobalsystems/service/communicator.dart';
// import 'package:flutter/material.dart';
// import 'package:loading/indicator/ball_pulse_indicator.dart';
// import 'package:loading/loading.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sms_maintained/sms.dart';
//
// class LoadingScreenExample extends StatefulWidget {
//   @override
//   LoadingScreenExampleState createState() => LoadingScreenExampleState();
// }
//
// class LoadingScreenExampleState extends State<LoadingScreenExample> {
//
//   double devicePhone;
//   String deviceId;
//   Map<String, dynamic> selectedDevice = Map<String, dynamic>();
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//
//
//   initState(){
//     super.initState();
//
//     init();
//     newinit();
//   }
//
//   newinit() {
//
//   }
//
//
//   init() {
//
//
//     SmsReceiver receiver = new SmsReceiver();
//
//     receiver.onSmsReceived.listen((SmsMessage msg) async {
//
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       var deviceData = json.decode(pref.getString('selectedDevice'));
//       Map<String, dynamic> status = Map<String, dynamic>();
//
//       if (deviceData['device'].toStringAsFixed(0).contains(msg.sender.substring(2))) {
//
//         String bodyData = msg.body.toLowerCase();
//
//         if (bodyData.contains('tracker is activated')) {
//           User data = User.fromJson(json.decode(pref.getString('userData')));
//
//           Communicator.updateStatus("arm", "on", deviceData['device'].toString(), data.id);
//           data.devices.first.status.arm = "on";
//           pref.setString('userData', json.encode(data));
//
//
//           deviceData['status'] = status;
//           // change data to string and save it
//
//           Timer(Duration(milliseconds: 3000), (){
//             Navigator.popAndPushNamed(context, 'home');
//           });
//
//         }else if(bodyData.contains('tracker is deactivated')){
//           User data = User.fromJson(json.decode(pref.getString('userData')));
//
//           Communicator.updateStatus("arm", "off", deviceData['device'].toString(), data.id);
//
//           data.subscription.commands = data.subscription.commands - 1;
//           data.devices[0].status.arm = "off";
//           pref.setString('userData', json.encode(data));
//
//           deviceData['status'] = status;
//
//           Timer(Duration(milliseconds: 3000), (){
//             Navigator.popAndPushNamed(context, 'home');
//           });
//
//         }else if(bodyData.contains('lat')) {
//
//           Tracking track = new Tracking();
//
//           String message = msg.body;
//           List<String> members = message.split("\n");
//
//           for (var item in members) {
//             List<String> cord = item.split(":");
//
//             switch (cord[0]) {
//               case 'lat':
//                 track.latitude= double.parse(cord[1]);
//                 break;
//
//               case 'long':
//                 track.longitude = double.parse(cord[1]);
//                 break;
//
//               case 'speed':
//                 track.speed = double.parse(cord[1]);
//                 break;
//
//               default:
//             }
//
//           }
//
//           User data = User.fromJson(json.decode(pref.getString('userData')));
//
//           data.subscription.commands = data.subscription.commands - 1;
//           pref.setString('userData', json.encode(data));
//
//           print("place");
//
//           int myInt = deviceData['device'];
//
//           track.id = data.id;
//           track.device = myInt;
//
//           String trackingData = json.encode(track.toJson());
//
//           pref.setString('tracking', trackingData);
//
//           print(track);
//           print("tracking data");
//
//           Communicator.addTracking(track);
//
//           Navigator.popAndPushNamed(_scaffoldKey.currentContext, 'maps');
//
//         }else if(bodyData.contains("speed ok!") || bodyData.contains("nospeed ok") ||
//             bodyData.contains("quickstop ok!") || bodyData.contains("noquickstop ok!") ||
//             bodyData.contains("move ok") || bodyData.contains("nomove ok") ||
//             bodyData.contains("noacc ok") || bodyData.contains("acc ok") ||
//             bodyData.contains("extpower on ok") || bodyData.contains("extpower on ok")){
//
//
//           Navigator.pop(context);
//         }else if(bodyData.contains("stop engine succeed")){
//
//           User data = User.fromJson(json.decode(pref.getString('userData')));
//           print(deviceData);
//
//           Communicator.updateStatus("power", "on", deviceData['device'].toString(), data.id);
//
//           Timer(Duration(milliseconds: 2000), (){
//             Navigator.popAndPushNamed(context, 'home');
//           });
//
//
//         }else if(bodyData.contains("resume engine succeed")) {
//
//           User data = User.fromJson(json.decode(pref.getString('userData')));
//           Communicator.updateStatus("power", "off", deviceData['device'].toString(), data.id);
//
//           deviceData['status'] = status;
//
//           Timer(Duration(milliseconds: 2000), (){
//             Navigator.popAndPushNamed(context, 'home');
//           });
//
//         }else if(bodyData.contains("bat")) {
//           var parts = bodyData.split(" ");
//           var place = parts[0].split('=');
//           var cords = place[1].split(',');
//
//           Tracking track = new Tracking();
//
//           track.latitude = double.parse(cords[0]);
//           track.longitude = double.parse(cords[1]);
//
//           print(track.toJson());
//           User data = User.fromJson(json.decode(pref.getString('userData')));
//
//           int myInt = deviceData['device'];
//
//           track.id = data.id;
//           track.device = myInt;
//
//           String trackingData = json.encode(track.toJson());
//
//           pref.setString('tracking', trackingData);
//
//           print(track);
//           print("tracking data");
//
//           Communicator.addTracking(track);
//
//           Navigator.popAndPushNamed(_scaffoldKey.currentContext, 'maps');
//
//           print("hs");
//         }else if(bodyData.contains("set ok")) {
//           var switchs = pref.getString("TS906");
//
//           User data = User.fromJson(json.decode(pref.getString('userData')));
//           print(deviceData);
//
//           if(switchs == "killswitchon"){
//
//             Communicator.updateStatus("power", "on", deviceData['device'].toString(), data.id);
//
//             Timer(Duration(milliseconds: 2000), (){
//               Navigator.popAndPushNamed(context, 'home');
//             });
//           }else if(switchs == "killswitchoff") {
//             Communicator.updateStatus("power", "off", deviceData['device'].toString(), data.id);
//
//             Timer(Duration(milliseconds: 2000), (){
//               Navigator.popAndPushNamed(context, 'home');
//             });
//           }else if( switchs == "armon") {
//             User data = User.fromJson(json.decode(pref.getString('userData')));
//
//             Communicator.updateStatus("arm", "on", deviceData['device'].toString(), data.id);
//
//             data.subscription.commands = data.subscription.commands - 1;
//             data.devices[0].status.arm = "on";
//             pref.setString('userData', json.encode(data));
//
//
//             deviceData['status'] = status;
//
//
//
//             Timer(Duration(milliseconds: 3000), (){
//               Navigator.popAndPushNamed(context, 'home');
//             });
//           }else if( switchs == "armoff") {
//             User data = User.fromJson(json.decode(pref.getString('userData')));
//
//             Communicator.updateStatus("arm", "off", deviceData['device'].toString(), data.id);
//
//             data.subscription.commands = data.subscription.commands - 1;
//             data.devices[0].status.arm = "off";
//             pref.setString('userData', json.encode(data));
//
//
//             deviceData['status'] = status;
//
//
//
//             Timer(Duration(milliseconds: 3000), (){
//               Navigator.popAndPushNamed(context, 'home');
//             });
//           }
//
//
//         }
//
//         Communicator.updateCommands();
// //        var sub = json.decode(pref.getString('subs'));
// //        if(sub['type'] == 'PayAsYouGo'){
// //          sub['commands'] = sub['commands'] - 1;
// //
// //
// //          pref.setString('subs', json.encode(sub));
// //          Communicator.updateCommands();
// //        }
//
//       }else{
//       }
//
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     // TODO: implement build
//     return Scaffold(
//       key: _scaffoldKey,
//         body: Stack(
//           children: <Widget>[
//             Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(image: ExactAssetImage('image/background2.png'),
//                     fit: BoxFit.cover),
//               ),
//             ),
//             Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text("Waiting for Device", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
//                   Loading(indicator: BallPulseIndicator(), size: 100.0)
//                 ],
//               ),
//             )
//           ],
//         ),
//       );
//   }
//
// }