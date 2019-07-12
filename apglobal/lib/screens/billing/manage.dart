
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

        item.add(Card(
            margin: EdgeInsets.only(top: 15, left: 15, right: 15),
            color: Color(0xFF0081b0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Master Card', style: TextStyle(color: Colors.white, fontSize: 16),),
                Text('***********${cardNumber.substring(cardNumber.length - 4)}', style: TextStyle(color: Colors.white, fontSize: 14),),
                Text('Status: $trueStage', style: TextStyle(color: Colors.white),),
              ],
            ),
            ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                     IconButton(onPressed: (){
                       showDialog(
                         context: context,
                         builder: (BuildContext context) {
                           return AlertDialog(
                             backgroundColor: Colors.grey[100],
                             content: Container(
                               height: 200,
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: <Widget>[
                                 Text('Please provide the amount that was charged on your card.', textAlign: TextAlign.center,),
                                 TextField(
                                   decoration: InputDecoration(
                                     filled: true,
                                     fillColor: Colors.white,
                                       border: new OutlineInputBorder(
                                         borderRadius: const BorderRadius.all(
                                           const Radius.circular(7.0),
                                         ),
                                       ),
                                       hintText: 'Eg 2.35'
                                   ),
                                   controller: amount,
                                 ),
                                 RaisedButton(
                                   child: Text('Save', style: TextStyle(color: Colors.white),),
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
                              color: Colors.grey[500],
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
      appBar: AppBar(title: Text('BILLING'), centerTitle: true,
          bottom: PreferredSize(child: Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text('Add card by clicking on the "+" icon', style: TextStyle(color: Colors.white, fontSize: 14)),),
              preferredSize: Size.fromHeight(60.0))),
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