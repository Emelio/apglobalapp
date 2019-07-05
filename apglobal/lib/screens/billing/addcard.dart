
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
        obscureText: false,
        keyboardType: type,
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
          TextfieldObject('Card Expiration Date (MM/YYYY)', TextInputType.datetime, dateis),
          TextfieldObject('Card CVV', TextInputType.number, cvv),
          
          Container(
            padding: EdgeInsets.all(25),
            child: RaisedButton(
              child: Text('Add Card', style: TextStyle(color: Colors.white),),
              onPressed: () async {
                Map<String, dynamic> paymentInfo = Map<String, dynamic>();

                paymentInfo['Cvv'] = cvv.text;
                paymentInfo['CardNumber'] = cardNumber.text;
                paymentInfo['ExpirationDate'] = dateis.text;

                var result = await Communicator.addCard(paymentInfo);

                if(result == 'done'){
                  print(result);
                }
              },
            ),
          )


        ],
      ),
    );
  }

}