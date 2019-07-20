
import 'dart:convert';

import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddCard extends StatefulWidget {
  State<AddCard> createState() => AddCardState();
}

class AddCardState extends State<AddCard> {

  TextEditingController cardNumber = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController dateis = TextEditingController();
  TextEditingController cvv = TextEditingController();
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
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text('Payment Details'), centerTitle: true,),
      body: ListView(
        children: <Widget>[

          TextfieldObject('Card Number', cardNumber),
          TextfieldObject('Card Expiration Date (MM/YYYY)', dateis),
          TextfieldObject('Card CVV', cvv),
          
          Container(
            padding: EdgeInsets.all(25),
            child: RaisedButton(
              child: Text('Add Card', style: TextStyle(color: Colors.white),),
              onPressed: () async {

                _showDialog(status);

                Map<String, dynamic> paymentInfo = Map<String, dynamic>();

                paymentInfo['Cvv'] = cvv.text;
                paymentInfo['CardNumber'] = cardNumber.text;
                paymentInfo['ExpirationDate'] = dateis.text;
                paymentInfo['ItemId'] = '';
                paymentInfo['UserId'] = '';

                var result = await Communicator.addCard(paymentInfo);

                Map<String, dynamic> paymentData = json.decode(result);

                if(paymentData['finalStatus'] == 'success'){
                   Navigator.popAndPushNamed(context, 'managecard');
                }else{
                  print(paymentData);
                  setState(() {
                    status = paymentData['message'];
                  });
                  _showDialog(paymentData['message']);
                }

                
              },
            ),
          )


        ],
      ),
    );
  }

}