


import 'dart:collection';
import 'dart:convert';

import 'package:apglobalsystems/service/communicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  Map<String, dynamic> cards = await Communicator.getCard();
  cards['cardDetails'].forEach((card) {
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
      appBar: AppBar(title: Text("Payment"), centerTitle: true,),
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

                _showDialog(status);

                Map<String, dynamic> paymentInfo = Map<String, dynamic>();

                setState(() {
              note = "payment is currently processing, please wait"; 
              });

                SharedPreferences pref = await SharedPreferences.getInstance();
                Map<String, dynamic> userData = json.decode(pref.getString('user'));
                String type = pref.getString('subType');

                paymentInfo['CardCVV'] = cvv.text;
                paymentInfo['cardNumber'] = _value;
                paymentInfo['expired'] = dateis.text;
                paymentInfo['name'] = "${userData['fname']} ${userData['lname']}";
                paymentInfo['address1'] = userData['address']['address1'];
                paymentInfo['city'] = userData['address']['city'];
                paymentInfo['state'] = userData['address']['state'];
                paymentInfo['parish'] = userData['address']['state'];
                paymentInfo['id'] = userData['id'];
                paymentInfo['type'] = type;
                paymentInfo['ItemId'] = type;
                paymentInfo['UserId'] = '';
                
                print(json.encode(paymentInfo));

                var result = await Communicator.payForSubscription(paymentInfo);

                print(result);

                Map<String, dynamic> paymentData = json.decode(result);

                print(paymentData['payments']);

                if(paymentData['payments']['finalStatus'] == 'success'){
                  Navigator.popAndPushNamed(context, 'billing');
                }else{
                  print(paymentData);
                  setState(() {
                    status = paymentData['payments']['message'];
                  });
//                  _showDialog(paymentData['message']);
                Navigator.pop(context);
                }


              },
            ),


          ),



        ],
      ),
    );;
  }

}