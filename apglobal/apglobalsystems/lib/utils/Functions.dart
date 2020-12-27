import 'package:geocoder/geocoder.dart';

class Functions {

  static getAddressFromLocation(double lat, double long) async {

    final coordinates = new Coordinates(lat, long);
    List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    Address ad = addresses.first;
    return ad.addressLine;
  }
}