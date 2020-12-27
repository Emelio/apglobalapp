
import 'dart:async';
import 'dart:convert';

import 'package:apglobalsystems/service/communicator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Maps extends StatefulWidget {

  @override
  State<Maps> createState() => MapSampleState();
}

class MapSampleState extends State<Maps> {

  static LatLng latLng = new LatLng(37.42796133580664, -122.085749655962);
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool runOnce = false;
  String dropdownValue = 'Now';


  init(dynamic device) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    Map<String, dynamic> trackingData = await Communicator().getTrackingData(device);


    if(trackingData != null){

      setState(() {
       latLng = LatLng(trackingData['latitude'], trackingData['longitude']);
        _goToTheLake(latLng);



       markers[MarkerId("mark1")] = Marker(
         markerId: MarkerId("mark1"),
         position: latLng,
         infoWindow: InfoWindow(title: "car 1", snippet: '*'),
         onTap: () {
           //_onMarkerTapped(markerId);
         },);
      });

    }

  }

   

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;

    if(!runOnce){
      init(args);
      runOnce = true;
    }

    print(latLng);
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Map"), 
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.popAndPushNamed(context, 'home'),),),
        body: Stack(
          children: <Widget>[

            GoogleMap(
              mapType: MapType.hybrid,
              markers: Set<Marker>.of(markers.values),
              initialCameraPosition: CameraPosition( target: LatLng(37.43296265331129, -122.08832357078792), zoom: 5.4746, ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Container(
              color: Colors.white,
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 0,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['Now', 'Today', 'Yesterday']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        )
      );
  }

  Future<void> _goToTheLake(LatLng newLat) async {

    CameraPosition _kLake = CameraPosition(
      bearing: 0.8334901395799,
      target: latLng,
      tilt: 0,
      zoom: 14.151926040649414);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  //https://pub.dev/packages/google_maps_flutter#-readme-tab-

}