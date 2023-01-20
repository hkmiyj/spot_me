import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:spot_me/model/shelter.dart';
import 'package:spot_me/model/victims.dart';
import 'package:spot_me/utils/const.dart';
import 'package:spot_me/utils/shared_pref.dart';
import 'package:spot_me/view/topNav/shelter_page.dart';

class mapPg extends StatefulWidget {
  const mapPg({super.key});

  @override
  State<mapPg> createState() => _mapPgState();
}

class _mapPgState extends State<mapPg> with TickerProviderStateMixin {
  late MapController mapController;
  late LatLng position;
  List<Marker> markerShelter = [];
  List<Marker> markerVictim = [];

  late List<Widget> carouselItems;

  @override
  void initState() {
    super.initState();
    position = LatLng(2.271, 102.2876);
    position = getCurrentLatLngFromSharedPrefs();
    mapController = MapController();
  }

  void _addMarker() {
    final _shelters = Provider.of<List<Shelter>>(context);
    final _victim = Provider.of<List<Victim>>(context);

    for (var i = 0; i < _victim.length; i++) {
      markerVictim.add(new Marker(
        height: 30,
        width: 30,
        point: LatLng(_victim.elementAt(i).location.latitude,
            _victim.elementAt(i).location.longitude),
        builder: (ctx) => new Icon(
          Icons.flag,
          color: Colors.red,
        ),
      ));
    }

    for (var x = 0; x < _shelters.length; x++) {
      markerShelter.add(new Marker(
        height: 30,
        width: 30,
        point: LatLng(_shelters.elementAt(x).location.latitude,
            _shelters.elementAt(x).location.longitude),
        builder: (ctx) => new Icon(
          Icons.night_shelter,
          color: Colors.red,
        ),
      ));
    }
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
    _addMarker();
    return Scaffold(
        body: Center(
          child: Stack(children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                  maxBounds: LatLngBounds(
                    LatLng(-90, -180.0),
                    LatLng(90.0, 180.0),
                  ),
                  onMapCreated: _onMapController,
                  plugins: [LocationMarkerPlugin(), MarkerClusterPlugin()],
                  center: position,
                  zoom: 6.8,
                  interactiveFlags:
                      InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                  maxZoom: 15,
                  minZoom: 1 //6.8,
                  ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/damfud/cl7n4wktc001v16lnqcz7i2z8/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZGFtZnVkIiwiYSI6ImNsN2s3dHNoMzBmOWIzb3F6OWkyMnM0ZWoifQ.N022hvg6-KtFSQ7NqetikQ",
                  additionalOptions: {"access_token": mapPk_AccessToken},
                ),
                LocationMarkerLayerOptions(headingStream: Stream.empty()),
                MarkerClusterLayerOptions(
                  maxClusterRadius: 100,
                  size: Size(40, 40),
                  fitBoundsOptions: FitBoundsOptions(
                    padding: EdgeInsets.all(50),
                  ),
                  markers: markerVictim,
                  polygonOptions: PolygonOptions(
                      borderColor: Colors.blueAccent,
                      color: Colors.black12,
                      borderStrokeWidth: 3),
                  builder: (context, markers) {
                    return FloatingActionButton(
                      child:
                          Icon(Icons.flag), //Text(markers.length.toString()),
                      onPressed: null,
                    );
                  },
                ),
                MarkerClusterLayerOptions(
                  maxClusterRadius: 100,
                  size: Size(40, 40),
                  fitBoundsOptions: FitBoundsOptions(
                    padding: EdgeInsets.all(50),
                  ),
                  markers: markerShelter,
                  polygonOptions: PolygonOptions(
                      borderColor: Colors.blueAccent,
                      color: Colors.black12,
                      borderStrokeWidth: 3),
                  builder: (context, markers) {
                    return FloatingActionButton(
                      child:
                          Icon(Icons.home), //Text(markers.length.toString()),
                      onPressed: null,
                    );
                  },
                ),
              ],
              nonRotatedChildren: [],
            ),
            SafeArea(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => shelter_page()),
                  );
                },
                child: Text("Register Shelter"),
                style: ElevatedButton.styleFrom(shape: StadiumBorder()),
              ),
            ),
          ]),
        ),
        floatingActionButton: Row(
          children: [
            FloatingActionButton.small(
              onPressed: () {
                _animatedMapMove(position, 18);
              },
              child: Icon(Icons.my_location),
            ),
            FloatingActionButton.small(
              child: Icon(Icons.flip_to_back),
              backgroundColor: Colors.red,
              onPressed: () {
                _animatedMapMove(position, 6.5);
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat);
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
