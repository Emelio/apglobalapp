


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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text("$status", style: TextStyle(color: Colors.red),),],),
      Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: DropdownButton<String>(
          hint: Text('Select Card'),
          items: [
            DropdownMenuItem(
              value: "1",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "build",
                  ),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "2",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Setting",
                  ),
                ],
              ),
            ),
          ],
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
              child: Text('Add Card', style: TextStyle(color: Colors.white),),
              onPressed: () async {
                Map<String, dynamic> paymentInfo = Map<String, dynamic>();

                SharedPreferences pref = await SharedPreferences.getInstance();
                String type = pref.getString('subType');

                paymentInfo['Cvv'] = cvv.text;
                paymentInfo['CardNumber'] = cardNumber.text;
                paymentInfo['ExpirationDate'] = dateis.text;
                paymentInfo['ItemId'] = type;
                paymentInfo['UserId'] = '';

                var result = await Communicator.payForSubscription(paymentInfo);

                Map<String, dynamic> paymentData = json.decode(result);

                if(paymentData['finalStatus'] == 'success'){
                  Navigator.popAndPushNamed(context, 'managecard');
                }else{
                  print(paymentData['finalStatus']);
                  setState(() {
                    status = paymentData['finalStatus'];
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