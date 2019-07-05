
import 'dart:convert';

import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';

class AddCard extends StatelessWidget {

  TextEditingController cardNumber = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController dateis = TextEditingController();
  TextEditingController cvv = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();


  TextfieldObject(String label, TextInputType type, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child:
      TextField(
        controller: controller,
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

          TextfieldObject('Card Number', TextInputType.text, cardNumber),
          TextfieldObject('Card Expiration Date (MM/YYYY)', TextInputType.text, dateis),
          TextfieldObject('Card CVV', TextInputType.text, cvv),
          
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
                   Navigator.pop(context);
                }

                
              },
            ),
          )


        ],
      ),
    );
  }

}