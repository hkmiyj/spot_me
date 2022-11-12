import 'dart:async';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:spot_me/model/userLocation.dart';
import 'package:location/location.dart';

class LocationService {
  late UserLocation _currentLocation;
  Location location = Location();
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService() {
    // Request permission to use location
    location.requestPermission().then((granted) {
      // If granted listen to the onLocationChanged stream and emit over our controller
      location.onLocationChanged.listen((locationData) {
        if (locationData != null) {
          _locationController.add(UserLocation(
            latitude: locationData.latitude!,
            longitude: locationData.longitude!,
          ));
        }
      });
    });
  }

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude!,
        longitude: userLocation.longitude!,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return _currentLocation;
  }
}

/*getCurrentLocation() async {
  Position _position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return _position;
}*/
getCoordinateToAddress(lat, long) async {
  List<geo.Placemark> p = await geo.placemarkFromCoordinates(lat, long);
  geo.Placemark place = p[0];
  String address;

  return address =
      "${place.name}, ${place.subLocality} ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}";
}

getAddresstoCoordinate(placemarks) async {
  List<geo.Location> _locations = await geo.locationFromAddress(placemarks);
  return _locations;
}
