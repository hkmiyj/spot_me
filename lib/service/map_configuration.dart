import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../main.dart';

class mapConfiguration {
  // MapBox Public Access Token
  String AccessToken =
      'pk.eyJ1IjoiZGFtZnVkIiwiYSI6ImNsN2s3dHNoMzBmOWIzb3F6OWkyMnM0ZWoifQ.N022hvg6-KtFSQ7NqetikQ';
  late LatLng LocationCoordinate;
  // Capture User Location
  Future<void> UserLocation() async {
    var location = Location();
    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) {
        return;
      }
    }

    var permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }

    var loc = await location.getLocation();
    LocationCoordinate = LatLng(loc.latitude!, loc.longitude!);

    // Store the user location in sharedPreferences
    sharedPreferences.setDouble('latitude', loc.latitude!);
    sharedPreferences.setDouble('longitude', loc.longitude!);
    // print("${getLocation().latitude} ${getLocation().longitude}");
  }

  getcurrentPostion() {
    return LocationCoordinate;
  }
}
