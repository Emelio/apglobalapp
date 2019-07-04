
import 'package:flutter/material.dart';

class ManageCard extends StatefulWidget {
  State<ManageCard> createState() => ManageCardState();
}


class ManageCardState extends State<ManageCard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Cards'), centerTitle: true,),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0)),
              // Box decoration takes a gradient
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  // Colors are easy thanks to Flutter's Colors class.
                  Colors.blue[800],
                  Colors.blue[600],
                  Colors.blue[600],
                  Colors.blue[800],
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('***********1111', style: TextStyle(color: Colors.white, fontSize: 20),),
                Text('last used:', style: TextStyle(color: Colors.white),)
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0)),
              // Box decoration takes a gradient
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  // Colors are easy thanks to Flutter's Colors class.
                  Colors.blue[800],
                  Colors.blue[600],
                  Colors.blue[600],
                  Colors.blue[800],
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('***********1111', style: TextStyle(color: Colors.white, fontSize: 20),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('last used:', style: TextStyle(color: Colors.white),),
                    IconButton(onPressed: (){}, icon: Icon(Icons.delete_forever), color: Colors.white,)
                  ],
                )
              ],
            ),
          ),


        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, 'addCard');
      },
        child: Icon(Icons.add),),
    );
  }

}