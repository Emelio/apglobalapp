
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:sms/sms.dart';

class LoadingScreenExample extends StatefulWidget {
  @override
  LoadingScreenExampleState createState() => LoadingScreenExampleState();
}

class LoadingScreenExampleState extends State<LoadingScreenExample> {
  SmsReceiver receiver = new SmsReceiver();

  LoadingScreenExampleState() {
    receiver.onSmsReceived.listen((SmsMessage msg) => print(msg));
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'Loading Screen Example',
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: ExactAssetImage('image/background2.png'),
                    fit: BoxFit.cover),
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Waiting for Device", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
                  Loading(indicator: BallPulseIndicator(), size: 100.0)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
}