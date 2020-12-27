
import 'package:apglobalsystems/service/communicator.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class DeviceList extends StatefulWidget {
  @override
  State<DeviceList> createState() => DeviceListState();
}

class DeviceListState extends State<DeviceList> {

  List<Widget> cars = new List();
  List<dynamic> carsRawData = new List();

  DeviceListState(){
    // Communicator.getDeviceList().then((result){
    //   if(result == null) {
    //     Navigator.popAndPushNamed(context, 'login');
    //   }else {
    //     setState(() {
    //       carsRawData = result['devices'];
    //       cars = listOfDevices();
    //     });
    //   }
    // });
  }


  List<Widget> listOfDevices() {
    
    List<Widget> cardata = List();
    for (var i = 0; i < carsRawData.length; i++) {
print(carsRawData[i]);
      var brand = carsRawData[i]['brand'];
      var model = carsRawData[i]['model'];
      var year = carsRawData[i]['year'];
      var arm = carsRawData[i]['status']['arm'];
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
                Text('$brand $model $year')
              ],
            ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Door: $arm'),
                Text('ACC: null'),
                Text('Power: null'),
               // GestureDetector(child: IconButton(icon: Icon(Icons.refresh),), onLongPress: (){},)
              ],
            )
          ],
        ),
      ),
      onTap: (){

      },
      )
    );
    }
    
    return cardata;

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fleet'),
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.popAndPushNamed(context, 'home'),),
        ),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          children: listOfDevices(),
        ),
        backgroundColor: Color(0xFFD3D3D3),
      ),
    );
  }

}