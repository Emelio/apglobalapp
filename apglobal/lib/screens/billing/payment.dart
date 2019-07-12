


import 'dart:convert';

import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  State<Payment> createState() => PaymentState();
}

class PaymentState extends State<Payment> {

  TextEditingController cardNumber = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController dateis = TextEditingController();
  TextEditingController cvv = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Payment"),),
      body: ListView(
        children: <Widget>[

      Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child:
      TextField(
        controller: cardNumber,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Card Number',
        ),
      ),
    ),

    Container(
    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
    child:
    TextField(
    controller: dateis,
    decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Card Expiration Date (MM/YYYY)',
    ),
    ),
    ),

    Container(
    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
    child:
    TextField(
    controller: cvv,
    decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Card CVV',
    ),
    ),
    ),

          Container(
            padding: EdgeInsets.all(25),
            child: RaisedButton(
              child: Text('Add Card', style: TextStyle(color: Colors.white),),
              onPressed: () async {
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
                }

                
              },
            ),
          )


        ],
      ),
    );;
  }
  
}