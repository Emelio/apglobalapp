
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Homestate createState() => Homestate();
}

class Homestate extends State<Home> {

  heading() {
    return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: (){

                      },
                      icon: Icon(Icons.more_vert, color: Colors.white,),
                    ),
                    Text('Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
                  margin: EdgeInsets.symmetric(vertical: 70, horizontal: 0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        child: Text('Toyota Probox 2012', style: TextStyle(color: Colors.white, fontSize: 28),),
                      ),
                      Text('now at:', style: TextStyle(color: Colors.white)),
                      Text('no data',style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),

                Image(image: ExactAssetImage('image/car_outline.png'), height: 160,)
              ],
            )
          ],
        ),
      )
    );
  }

}