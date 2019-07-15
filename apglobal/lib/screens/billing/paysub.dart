


import 'dart:collection';
import 'dart:convert';

import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaySub extends StatefulWidget {
  State<PaySub> createState() => PaySybState();
}

class PaySybState extends State<PaySub> {

  TextEditingController cardNumber = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController dateis = TextEditingController();
  TextEditingController cvv = TextEditingController();
  String status = '';
  var _value ;
  List<DropdownMenuItem<String>> cardNumbers = new List(); 
  String note = '';

PaySybState() {
  getCards();
}

getCards() async {
  List<DropdownMenuItem<String>> cardData = new List();
  List<dynamic> cards = await Communicator.getCard();
  cards.forEach((card) {
    double cardDataString = card['cardNumber'];
    
    if(card['finalStatus'] == 'success') {
      cardData.add(DropdownMenuItem(
              value: "${cardDataString.toStringAsFixed(0)}",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${cardDataString.toStringAsFixed(0)}",
                  ),
                ],
              ),
            ));
    }
  });

  setState(() {
    cardNumbers = cardData;
  });

}

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
      appBar: AppBar(title: Text("Payment"),),
      body: ListView(
        
        children: <Widget>[
          Text('$note', textAlign: TextAlign.center,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text("$status", style: TextStyle(color: Colors.red),),],),
      Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: DropdownButton<String>(
          hint: Text('Select Card'),
          items: cardNumbers,
          onChanged: (value) {
            setState(() {
              _value = value;
            });
          },
          value: _value,
          isExpanded: true,
        ),),

          //TextfieldObject('Card Number', TextInputType.text, cardNumber),
          TextfieldObject('Card Expiration Date (MM/YYYY)', TextInputType.text, dateis),
          TextfieldObject('Card CVV', TextInputType.text, cvv),




          Container(
            padding: EdgeInsets.all(25),
            child: RaisedButton(
              child: Text('Pay Now', style: TextStyle(color: Colors.white),),
              onPressed: () async {
                Map<String, dynamic> paymentInfo = Map<String, dynamic>();

                setState(() {
              note = "payment is currently processing, please wait"; 
              });

                SharedPreferences pref = await SharedPreferences.getInstance();
                String type = pref.getString('subType');

                paymentInfo['Cvv'] = cvv.text;
                paymentInfo['CardNumber'] = _value;
                paymentInfo['ExpirationDate'] = dateis.text;
                paymentInfo['ItemId'] = type;
                paymentInfo['UserId'] = '';

                var result = await Communicator.payForSubscription(paymentInfo);

                print(result);

                Map<String, dynamic> paymentData = json.decode(result);

                if(paymentData['finalStatus'] == 'success'){
                  Navigator.popAndPushNamed(context, 'billing');
                }else{
                  print(paymentData['finalStatus']);
                  setState(() {
                    status = paymentData['message'];
                  });
                }


              },
            ),


          ),



        ],
      ),
    );;
  }

}