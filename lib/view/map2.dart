import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:spot_me/service/map_configuration.dart';
import 'package:spot_me/utils/shared_pref.dart';

class mapPg extends StatefulWidget {
  const mapPg({super.key});

  @override
  State<mapPg> createState() => _mapPgState();
}

class _mapPgState extends State<mapPg> with TickerProviderStateMixin {
  late MapController mapController;
  late LatLng position;

  @override
  void initState() {
    super.initState();
    position = LatLng(1, 1);
    position = getCurrentLatLngFromSharedPrefs();
    mapController = MapController();
  }

  void updateCurrentLocation() async {
    Location location = Location();
    LocationData _locationData;
    _locationData = await location.getLocation();
    position = LatLng(_locationData.latitude!, _locationData.longitude!);
  }

  void _onMapController(MapController controller) async {
    this.mapController = controller;
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          onMapCreated: _onMapController,
          plugins: [
            LocationMarkerPlugin(),
          ],
          center: position,
          zoom: 6.8,
          interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          maxZoom: 18,
          //minZoom: 6.8,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/damfud/cl7n4wktc001v16lnqcz7i2z8/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZGFtZnVkIiwiYSI6ImNsN2s3dHNoMzBmOWIzb3F6OWkyMnM0ZWoifQ.N022hvg6-KtFSQ7NqetikQ",
            additionalOptions: {"access_token": mapConfiguration().AccessToken},
          ),
          LocationMarkerLayerOptions(headingStream: Stream.empty()),
          /*CircleLayerOptions(
            circles: [],
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                point: position,
                width: 1,
                height: 1,
                builder: (context) => Icon(
                  Icons.person,
                  color: Colors.redAccent,
                  size: 30,
                ),
              ),
            ],
          ),*/
        ],
        nonRotatedChildren: [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _animatedMapMove(position, 18);
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
