
import 'package:flutter/material.dart';

class AddCard extends StatelessWidget {

  TextfieldObject(String label, TextInputType type) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child:
      TextField(
        obscureText: false,
        keyboardType: type,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: '$label',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[

          TextfieldObject('Name on Card', TextInputType.number),
          TextfieldObject('Card Number', TextInputType.text),
          TextfieldObject('Card Expiration Date (MM/YYYY)', TextInputType.datetime),
          TextfieldObject('Card CVV', TextInputType.number),
          TextfieldObject('Address 1', TextInputType.text),
          TextfieldObject('City', TextInputType.text),
          TextfieldObject('State', TextInputType.text),
          TextfieldObject('Country', TextInputType.text),
          
          Container(
            padding: EdgeInsets.all(25),
            child: RaisedButton(
              child: Text('Add Card', style: TextStyle(color: Colors.white),),
              
            ),
          )


        ],
      ),
    );
  }

}