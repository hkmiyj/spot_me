import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:location/location.dart';
import 'package:spot_me/service/map_configuration.dart';
import 'package:spot_me/utils/shared_prefs.dart';

//scrcpy
class map extends StatefulWidget {
  const map({Key? key}) : super(key: key);

  @override
  State<map> createState() => _mapState();
}

class _mapState extends State<map> {
  late LatLng position;
  CameraPosition _initialCameraPosition =
      CameraPosition(target: LatLng(0, 0), zoom: 15);
  late MapboxMapController mapController;

  @override
  void initState() {
    super.initState();
    mapConfiguration().UserLocation();
    position = getCurrentLatLngFromSharedPrefs();
    _initialCameraPosition = CameraPosition(target: position, zoom: 15);
  }

  void _onMapCreated(MapboxMapController controller) async {
    this.mapController = controller;
  }

  _onStyleLoadedCallback() async {
    await mapController.addSymbol(SymbolOptions(
      geometry: position,
      iconSize: 0.2,
      iconImage: "asset/images/navigation.png",
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SizedBox(
              child: MapboxMap(
                accessToken: mapConfiguration().AccessToken,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: _onMapCreated,
                onStyleLoadedCallback: _onStyleLoadedCallback,
                myLocationEnabled: false,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mapController.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition));
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
