
import 'dart:convert';

import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';

class ManageCard extends StatefulWidget {
  State<ManageCard> createState() => ManageCardState();
}


class ManageCardState extends State<ManageCard> {
  List<Widget> cards = List();
  TextEditingController amount = new TextEditingController();

  ManageCardState(){
    listofCards();
  }

  listofCards() async {
   String cardsString = await Communicator.getCard();

   List<dynamic> cardsList = json.decode(cardsString); 
   
   List<Widget> item = List<Widget>(); 
   for (var i = 0; i < cardsList.length; i++) {

     double cardNumberdouble = cardsList[i]['cardNumber'];
     String cardNumber = cardNumberdouble.toStringAsFixed(0);

     String status = cardsList[i]['finalStatus'];

     String stage = cardsList[i]['stage'];

     if(status == 'success'){

       String trueStage; 
       if(stage == null)
       {
        trueStage = 'Not Verified';
       }else if(stage == 'verified'){
        trueStage = 'Verified';
       }

        item.add(Container(
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
                Text('***********${cardNumber.substring(cardNumber.length - 4)}', style: TextStyle(color: Colors.white, fontSize: 20),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('Status: $trueStage', style: TextStyle(color: Colors.white),),
                   
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                     IconButton(onPressed: (){
                       showDialog(
                         context: context,
                         builder: (BuildContext context) {
                           return AlertDialog(
                             content: Container(
                               height: 180,
                               child: Column(
                               children: <Widget>[
                                 Text('Please provide the amount that was charged on your card.'),
                                 TextField(
                                   controller: amount,
                                 ),
                                 RaisedButton(
                                   child: Text('Save'),
                                   onPressed: (){
                                     // update card 
                                     Communicator.verifyCard(cardNumber, double.parse(amount.text));
                                     Navigator.pushReplacementNamed(context, 'billing');
                                   },
                                 )
                               ],
                             ),
                             )
                           );
                         }
                       );
                     }, icon: Icon(Icons.assignment, size: 35,), color: Colors.white,),
                    IconButton(onPressed: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Container(
                              height: 120,
                              child: Column(
                              children: <Widget>[
                                Text("Are you sure you want to remove this card?"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RaisedButton(
                                      color: Colors.red,
                                      child: Text("Yes"),
                                      onPressed: (){
                                        Communicator.removeCard(cardNumber);
                                        Navigator.pushReplacementNamed(context, 'managecard');
                                      },
                                    ),
                                    RaisedButton(
                                      child: Text("No"),
                                      onPressed: () => Navigator.pop(context),
                                    )
                                  ],
                                )
                              ],
                            ),
                            )
                          );
                        }
                      );
                    }, icon: Icon(Icons.delete_forever, size: 35,), color: Colors.white,),
                   
                  ],
                )
              ],
            ),
          ),
);
 
     }else{
       // remember to delete card 
     }
     
      }

   setState(() {
    cards = item;  
   });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Cards'), centerTitle: true,),
      body: ListView(
        children: cards,
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, 'addCard');
      },
        child: Icon(Icons.add),),
    );
  }

}