
import 'dart:async';

import 'package:apglobal/service/communicator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'home.dart';

class Maps extends StatefulWidget {

  @override
  State<Maps> createState() => MapSampleState();
}

class MapSampleState extends State<Maps> {

  static LatLng latLng = new LatLng(37.42796133580664, -122.085749655962);
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  MapSampleState(){
    Communicator.getTracking().then((result) {
      setState(() {
        print(result);
        latLng = LatLng(result['lat'],result['longi']);
        _goToTheLake(LatLng(result['lat'],result['longi']));

        // creating a new MARKER
    final Marker marker = Marker(
      markerId: MarkerId("mark1"),
      position: latLng,
      infoWindow: InfoWindow(title: "car 1", snippet: '*'),
      onTap: () {
        //_onMarkerTapped(markerId);
      },
    );

    markers[MarkerId("mark1")] = marker;
      });
    });
  }

   

  @override
  Widget build(BuildContext context) {
    print(latLng);
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Map"), 
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.arrow_back),           
          onPressed: (){runApp(Home()); },),),
        body: GoogleMap(
          mapType: MapType.hybrid,
          markers: Set<Marker>.of(markers.values),
          initialCameraPosition: CameraPosition( target: LatLng(37.43296265331129, -122.08832357078792), zoom: 5.4746, ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
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