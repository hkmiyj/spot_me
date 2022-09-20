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
  List<Marker> allMarkers = [];

  late List<Widget> carouselItems;

  @override
  void initState() {
    super.initState();
    position = LatLng(2.271, 102.2876);
    position = getCurrentLatLngFromSharedPrefs();
    mapController = MapController();

    /*for(int i = 0; i < coords.length; i++) {
      allMarkers.add(
        new Marker(
          width: 80.0,
          height: 80.0,
          point: coords.values.elementAt(i),
          builder: (ctx) => new Icon(Icons.night_shelter, color: Colors.red,),
        )
      );
    }*/
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

  rescueBottomSheet() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Text('KarJay'),
            ElevatedButton(
              child: const Text('Mark As Found'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  shelterBottomSheet() {
    return showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(
                'https://images.unsplash.com/photo-1547721064-da6cfb341d50',
                fit: BoxFit.cover,
              ),
            ),
            const Text('PPS Melaka Hawau'),
            ElevatedButton(
              child: const Text('Go There'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('Call'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            onMapCreated: _onMapController,
            plugins: [
              LocationMarkerPlugin(),
            ],
            center: position,
            zoom: 6.8,
            interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            maxZoom: 15,
            minZoom: 6.8,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/damfud/cl7n4wktc001v16lnqcz7i2z8/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZGFtZnVkIiwiYSI6ImNsN2s3dHNoMzBmOWIzb3F6OWkyMnM0ZWoifQ.N022hvg6-KtFSQ7NqetikQ",
              additionalOptions: {
                "access_token": mapConfiguration().AccessToken
              },
            ),
            LocationMarkerLayerOptions(headingStream: Stream.empty()),
            MarkerLayerOptions(
              markers: [
                Marker(
                  point: LatLng(2.271, 102.2876),
                  builder: (context) => IconButton(
                    icon: Icon(Icons.night_shelter),
                    onPressed: () {
                      shelterBottomSheet();
                    },
                  ),
                ),
              ],
            ),
          ],
          nonRotatedChildren: [],
        ),
        Positioned(
            bottom: 80,
            right: 16,
            child: FloatingActionButton(
              child: Icon(Icons.home),
              backgroundColor: Colors.red,
              onPressed: () {
                rescueBottomSheet();
              },
            )),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _animatedMapMove(position, 18);
        },
        child: Icon(Icons.my_location),
      ),
    );
  }
}

class mapCarousel extends StatefulWidget {
  const mapCarousel({super.key});

  @override
  State<mapCarousel> createState() => _mapCarouselState();
}

class _mapCarouselState extends State<mapCarousel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Card(
        color: Colors.white,
      ),
    );
  }
}
