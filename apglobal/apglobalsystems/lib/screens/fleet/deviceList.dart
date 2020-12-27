import 'dart:convert';

import 'package:apglobalsystems/Model/User.dart';
import 'package:apglobalsystems/service/communicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../home.dart';

class DeviceList extends StatefulWidget {
  @override
  State<DeviceList> createState() => DeviceListState();
}

class DeviceListState extends State<DeviceList> {

  List<Widget> cars = new List();
  List<Devices> carsRawData = new List();

  @override
  void initState() {
    super.initState();





  }

  init() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    User user = User.fromJson(json.decode(pref.getString('userData')));
    print("init");

    // var devices = await Communicator.getDevices(user.id);

    setState(() {
     // carsRawData = devices;
    });
  }

  List<Widget> listOfDevices() {
    
    List<Widget> cardata = List();

    carsRawData.forEach((device) {

      if(device.status != null){
        var make = device.make;
        var model = device.model;
        var year = device.year;
        var arm = device.status.arm;

              cardata.add(
          GestureDetector(
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: null,
                  borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('$make $model $year')
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Arm: ${device.status.arm}'),
                      Text('Kill Switch: ${device.status.power}'),
                      Text('Plate: ${device.plate}'),
                      // GestureDetector(child: IconButton(icon: Icon(Icons.refresh),), onLongPress: (){},)
                    ],
                  )
                ],
              ),
            ),
            onTap: () async {
              SharedPreferences pref = await SharedPreferences.getInstance(); 
              pref.setString('viewingDevice', json.encode(device.toJson())); 
              Navigator.pushNamed(context, 'viewDevice', arguments: device);
            },
          )
      );

        print(device.status.arm);
      }else {
        print(device.toJson());
      }
    });
    return cardata;

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Fleet'),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.popAndPushNamed(context, 'home'),),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: (query) async {

                if(query.length > 2) {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  var user = json.decode(pref.getString("userData"));
                  var vehicles = await Communicator.searchVehicles(query, user['id']);

                  setState(() {
                    carsRawData = vehicles;
                  });

                }
              },
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0x6F02CBD8),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide.none
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide.none
                  ),
                  contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "Search by Plate Number, Make or Model"
              ),
            ),
          ),
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            children: listOfDevices(),
          )
        ],
      ),
      backgroundColor: Color(0xFFD3D3D3),
    );
  }

}