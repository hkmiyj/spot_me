import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/dragmarker.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:spot_me/model/userLocation.dart';
import 'package:spot_me/model/victims.dart';
import 'package:spot_me/service/location.dart';
import 'package:spot_me/utils/const.dart';
import 'package:spot_me/widget/showMap.dart';
import 'package:intl/intl.dart';

// https://www.youtube.com/watch?v=JiSsS1Xj5uQ

class locatePage extends StatefulWidget {
  const locatePage({super.key});

  @override
  State<locatePage> createState() => _locatePageState();
}

class _locatePageState extends State<locatePage> with TickerProviderStateMixin {
  late MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
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

  String timing(DateTime timestamp) {
    var format = DateFormat('HH:mm a');
    var sformat = DateFormat('EEEE, MMMM d, ' 'yyyy');
    var time = sformat.format(timestamp);
    return time;
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
      return distanceDiff.toStringAsFixed(2) + " KM";
    } else
      return _distanceInMeters.toInt().toString() + " M";
  }

  calcDistanceDiff(LatLng coordinate) {
    var userLocation = Provider.of<UserLocation>(context);
    var _distanceInMeters = Geolocator.distanceBetween(
      coordinate.latitude,
      coordinate.longitude,
      userLocation.latitude,
      userLocation.longitude,
    );
    return _distanceInMeters;
  }

  bottomSheetBar() {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final _victim = Provider.of<List<Victim>>(context);
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Choose a victim for more info"),
                ),
                Expanded(
                  child: SizedBox(
                    height: 200.0,
                    child: ListView.builder(
                      itemCount: _victim.length,
                      itemBuilder: ((context, index) {
                        _victim.sort((a, b) => (calcDistanceDiff(LatLng(
                                a.location.latitude, a.location.longitude)))
                            .compareTo(calcDistanceDiff(LatLng(
                                b.location.latitude, b.location.longitude))));
                        return ListTile(
                          leading: Icon(
                            Icons.account_circle,
                            color: Colors.red,
                            size: 45.0,
                          ),
                          title: Text(_victim.elementAt(index).name),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder<Object>(
                                  stream: null,
                                  builder: (context, snapshot) {
                                    return Text(calcTime(_victim
                                        .elementAt(index)
                                        .time
                                        .toDate()));
                                  }),
                            ],
                          ),
                          trailing: Text(calcDistance(LatLng(
                              _victim.elementAt(index).location.latitude,
                              _victim.elementAt(index).location.longitude))),
                          onTap: () {
                            print("test");
                          },
                          dense: true,
                          selected: false,
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _addMarker(victim, markerVictim) {
    for (var i = 0; i < victim.length; i++) {
      markerVictim.add(new Marker(
        height: 30,
        width: 30,
        point: LatLng(victim.elementAt(i).location.latitude,
            victim.elementAt(i).location.longitude),
        builder: (ctx) => FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.white,
          onPressed: () {
            victimInfo(victim.elementAt(i));
            _animatedMapMove(
                LatLng(victim.elementAt(i).location.latitude,
                    victim.elementAt(i).location.longitude),
                13);
          },
          child: Icon(
            Icons.flag,
            color: Colors.red,
          ),
        ),
      ));
    }
  }

  victimInfo(victim) {
    return showModalBottomSheet<void>(
        barrierColor: Colors.white.withOpacity(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                height: constraints.maxHeight / 2.8,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('You Request For Help',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        Container(
                          child: ListTile(
                            leading: RippleAnimation(
                                repeat: true,
                                color: Colors.blue,
                                minRadius: 15,
                                ripplesCount: 6,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                )),
                            title: Text(victim.name.toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(calcTime(victim.time.toDate())),
                              ],
                            ),
                          ),
                        ),
                        Card(
                            child: Column(children: [
                          ListTile(
                              title: Text(
                                "Description",
                              ),
                              subtitle: Text(victim.description)),
                          ListTile(
                            title: Text(
                              "Phone Number",
                            ),
                            subtitle: FutureBuilder<String>(
                              future: null,
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (victim.phoneNumb!.isNotEmpty) {
                                  return Text(victim.phoneNumb!);
                                } else {
                                  return Text(
                                    'Phone Not Found',
                                  );
                                }
                              },
                            ),
                          ),
                        ])),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Contact Them"),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final _victim = Provider.of<List<Victim>>(context);
    List<Marker> markerVictim = [];
    _addMarker(_victim, markerVictim);
    var userLocation = Provider.of<UserLocation>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locate Victim'),
        centerTitle: true,
      ),
      body: Container(
        child: SizedBox(
            child: FlutterMap(
          options: MapOptions(
            center: LatLng(userLocation.latitude, userLocation.longitude),
            zoom: 6.8,
            onMapCreated: _onMapController,
            interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            maxZoom: 15,
            minZoom: 6,
            plugins: [
              LocationMarkerPlugin(),
              DragMarkerPlugin(),
              MarkerClusterPlugin()
            ],
          ),
          children: [],
          layers: [
            TileLayerOptions(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/damfud/cl7n4wktc001v16lnqcz7i2z8/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZGFtZnVkIiwiYSI6ImNsN2s3dHNoMzBmOWIzb3F6OWkyMnM0ZWoifQ.N022hvg6-KtFSQ7NqetikQ",
              additionalOptions: {"access_token": mapPk_AccessToken},
            ),
            LocationMarkerLayerOptions(
              headingStream: Stream.empty(),
            ),
          ],
          nonRotatedChildren: [
            FloatingActionButton.small(
              child: Icon(Icons.keyboard_double_arrow_up),
              backgroundColor: Colors.red,
              onPressed: () {
                bottomSheetBar();
              },
            ),
          ],
        )),
      ),
    );
  }
}
