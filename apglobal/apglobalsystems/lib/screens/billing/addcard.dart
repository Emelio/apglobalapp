
import 'dart:convert';

import 'package:apglobalsystems/service/communicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCard extends StatefulWidget {
  State<AddCard> createState() => AddCardState();
}

class AddCardState extends State<AddCard> {

  TextEditingController cardNumber = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController dateis = TextEditingController();
  TextEditingController cvv = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController parish = TextEditingController();
  TextEditingController address = TextEditingController();

  String status = '';


  TextfieldObject(String label, TextEditingController controllers) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child:
      TextField(
        
        controller: controllers,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(14),
          labelText: '$label',
        ),
      ),
    );
  }

  void _showDialog(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Container(
          height: 200,
          child: AlertDialog(
              content: Container(
                height: 200,
                child: Column(
                  children: <Widget>[
                    Text("Please wait wil transaction processes", textAlign: TextAlign.center,),
                    Text("$message", style: TextStyle(color: Colors.red),),
                    SpinKitRipple(
                      color: Colors.blue,
                      size: 50.0,
                    ),
//                    RaisedButton(onPressed: () => Navigator.pop(context), child: Text("Edit Information"),)
                  ],
                ),
              )
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    country.text = "Jamaica";

    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text('Payment Details'), centerTitle: true,),
      body: ListView(
        children: <Widget>[

          TextfieldObject('Card Number', cardNumber),
          TextfieldObject('Card Expiration Date (MM/YYYY)', dateis),
          TextfieldObject('Card CVV', cvv),
          TextfieldObject('Card Address', address),
          TextfieldObject('Card City', city),
          TextfieldObject('Card Parish', parish),
          TextfieldObject('Card Country', country),

          
          Container(
            padding: EdgeInsets.all(25),
            child: RaisedButton(
              child: Text('Add Card', style: TextStyle(color: Colors.white),),
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();

                _showDialog(status);

                Map<String, dynamic> paymentInfo = Map<String, dynamic>();

                Map<String, dynamic> userData = json.decode(pref.getString('user'));

                paymentInfo['CardCVV'] = cvv.text;
                paymentInfo['cardNumber'] = cardNumber.text;
                paymentInfo['expired'] = dateis.text;
                paymentInfo['name'] = "${userData['fname']} ${userData['lname']}";
                paymentInfo['address1'] = address.text;
                paymentInfo['city'] = city.text;
                paymentInfo['state'] = parish.text;
                paymentInfo['parish'] = country.text;
                paymentInfo['id'] = userData['id'];
                paymentInfo['type'] = "PayAsYouGo";
                paymentInfo['ItemId'] = '';
                paymentInfo['UserId'] = '';

                var result = await Communicator.addCard(paymentInfo);

                Map<String, dynamic> paymentData = json.decode(result);

                if(paymentData['payments']['finalStatus'] == 'success'){
                   Navigator.popAndPushNamed(context, 'managecard');
                }else{
                  print(paymentData);
                  setState(() {
                    status = paymentData['payments']['message'];
                  });
                  _showDialog(paymentData['payments']['message']);
                }

                
              },
            ),
          )


        ],
      ),
    );
  }

}