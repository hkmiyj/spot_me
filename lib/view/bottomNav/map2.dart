import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:map_launcher/src/models.dart' as maps;
import 'package:provider/provider.dart';
import 'package:spot_me/model/shelter.dart';
import 'package:spot_me/model/userLocation.dart';
import 'package:spot_me/model/victims.dart';
import 'package:spot_me/utils/const.dart';
import 'package:spot_me/utils/shared_pref.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class mapPg extends StatefulWidget {
  const mapPg({super.key});

  @override
  State<mapPg> createState() => _mapPgState();
}

class _mapPgState extends State<mapPg> with TickerProviderStateMixin {
  late MapController mapController;
  late LatLng position;
  List<Marker> markerShelter = [];

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
    for (var x = 0; x < _shelters.length; x++) {
      final shelter = _shelters[x];
      markerShelter.add(new Marker(
        height: 30,
        width: 30,
        point: LatLng(_shelters.elementAt(x).location.latitude,
            _shelters.elementAt(x).location.longitude),
        builder: (ctx) => IconButton(
          onPressed: () {
            _animatedMapMove(
                LatLng(shelter.location.latitude, shelter.location.longitude),
                17);
            detailBottomSheet(shelter);
          },
          icon: Icon(
            Icons.night_shelter,
            color: Colors.red,
          ),
        ),
      ));
    }
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

  detailBottomSheet(Shelter shelter) {
    return showModalBottomSheet<void>(
        elevation: 0,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        context: context,
        builder: (
          BuildContext context,
        ) =>
            DraggableScrollableSheet(
              expand: false,
              builder: (BuildContext context, scrollController) {
                return SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Column(
                      children: [
                        Container(
                            child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shelter.name.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: FutureBuilder<String>(
                                  future: address(LatLng(
                                      shelter.location.latitude,
                                      shelter.location.longitude)),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> address) {
                                    if (address.hasData) {
                                      return Text(
                                        '${address.data}',
                                      );
                                    } else {
                                      return Text(
                                        'No address found',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  calcDistance(LatLng(shelter.location.latitude,
                                      shelter.location.longitude)),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.call,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final Uri launchUri = Uri(
                                      scheme: 'tel',
                                      path: shelter.phone,
                                    );
                                    await launchUrl(launchUri);
                                  },
                                ),
                                Container(
                                  child: Text(
                                    "Call",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      final availableMaps =
                                          await MapLauncher.installedMaps;
                                      print(availableMaps);
                                      showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                              height: 150,
                                              color: Colors.white,
                                              child: ListView(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                      child: Text("Choose Map",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  "WorkSansBold")),
                                                    ),
                                                  ),
                                                  for (var map in availableMaps)
                                                    ListTile(
                                                      onTap: () =>
                                                          map.showMarker(
                                                        coords: maps.Coords(
                                                            shelter.location
                                                                .latitude,
                                                            shelter.location
                                                                .longitude),
                                                        title: shelter.name,
                                                      ),
                                                      title: Text(
                                                        map.mapName,
                                                      ),
                                                      leading: SvgPicture.asset(
                                                        map.icon,
                                                        height: 30.0,
                                                        width: 30.0,
                                                      ),
                                                    ),
                                                ],
                                              ));
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.directions,
                                      size: 20,
                                      color: Colors.red,
                                    )),
                                Container(
                                  child: Text(
                                    "Map",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(
                            shelter.description,
                            softWrap: true,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    _addMarker();
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.red,
              shadows: <Shadow>[Shadow(color: Colors.black, blurRadius: 20.0)],
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
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

  calcTime(DateTime timestamp) {
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(timestamp);
    var sformat = DateFormat('yyyy/MM/dd hh:mm a');
    var time = sformat.format(timestamp);

    if (difference.inSeconds < 60) {
      return difference.inSeconds.toString() + " Seconds ago";
    } else if (difference.inMinutes < 60) {
      return difference.inMinutes.toString() + " Minutes Ago";
    } else if (difference.inHours < 24) {
      return difference.inHours.toString() + " Hour Ago";
    } else if (difference.inDays < 7) {
      return difference.inDays.toString() + " Days Ago";
    } else
      return time;
  }

  calcDistance(LatLng coordinate) {
    var userLocation = Provider.of<UserLocation>(context);
    var _distanceInMeters = Geolocator.distanceBetween(
      coordinate.latitude,
      coordinate.longitude,
      userLocation.latitude,
      userLocation.longitude,
    );
    double distanceDiff = _distanceInMeters / 1000;
    if (_distanceInMeters > 1000) {
      _distanceInMeters = _distanceInMeters / 1000;
      return distanceDiff.toStringAsFixed(2) + " Kilometer";
    } else
      return _distanceInMeters.toInt().toString() + " Meter";
  }

  Future<String> address(LatLng coordinate) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinate.latitude, coordinate.longitude);
    Placemark placeMark = placemarks[0];
    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    String address =
        "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
    return (address);
  }
}
