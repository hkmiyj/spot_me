import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/dragmarker.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:spot_me/model/userLocation.dart';
import 'package:spot_me/model/victims.dart';
import 'package:spot_me/utils/const.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/src/models.dart' as maps;
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
      return distanceDiff.toStringAsFixed(2) + " Kilometer";
    } else
      return _distanceInMeters.toInt().toString() + " Meter";
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

  bottomSheetBar() {
    return showModalBottomSheet<void>(
      barrierColor: Colors.white.withOpacity(0),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final _victim = Provider.of<List<Victim>>(context);
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
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
                            _animatedMapMove(
                                LatLng(
                                    _victim.elementAt(index).location.latitude,
                                    _victim
                                        .elementAt(index)
                                        .location
                                        .longitude),
                                17);
                            detailBottomSheet(_victim.elementAt(index));
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

  detailBottomSheet(victim) {
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
                        Expanded(child: Builder(builder: (context) {
                          if (victim.imageUrl == "") {
                            return Image.network(
                              "https://firebasestorage.googleapis.com/v0/b/spotme-0001.appspot.com/o/victims%2Fimage_not_found.png?alt=media&token=271c6311-9fdf-428e-a31d-e9a19a08e070",
                              width: 600,
                              height: 240,
                              fit: BoxFit.cover,
                            );
                          } else
                            return Image.network(
                              victim.imageUrl,
                              width: 600,
                              height: 240,
                              fit: BoxFit.cover,
                            );
                        })),
                        Container(
                            child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                victim.name.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              FutureBuilder<String>(
                                future: address(LatLng(victim.location.latitude,
                                    victim.location.longitude)),
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
                              Text(
                                calcDistance(LatLng(victim.location.latitude,
                                    victim.location.longitude)),
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                              StreamBuilder<Object>(
                                  stream: null,
                                  builder: (context, snapshot) {
                                    return Text(
                                      calcTime(victim.time.toDate()),
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                    );
                                  }),
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
                                    Icons.message,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    String text =
                                        "Hello Im am a volunteer from SpotMe, I am available to lend a hand, what can I do to help you ?";
                                    String url =
                                        "https://wa.me/${victim.phoneNumb}?text=${Uri.encodeFull(text)}";
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url),
                                          mode: LaunchMode.externalApplication);
                                    }
                                  },
                                ),
                                Container(
                                  child: Text(
                                    "Message",
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
                                  icon: Icon(
                                    Icons.call,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final Uri launchUri = Uri(
                                      scheme: 'tel',
                                      path: victim.phoneNumb,
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
                                  icon: Icon(
                                    Icons.track_changes,
                                    color: Colors.red,
                                  ),
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
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(
                                                        "Choose Map To Locate Victim",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                "WorkSansBold")),
                                                  ),
                                                ),
                                                for (var map in availableMaps)
                                                  ListTile(
                                                    onTap: () => map.showMarker(
                                                      coords: maps.Coords(
                                                          victim.location
                                                              .latitude,
                                                          victim.location
                                                              .longitude),
                                                      title: victim.name,
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
                                ),
                                Container(
                                  child: Text(
                                    "Locate",
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
                            victim.description,
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

  _addMarker(victim, markerVictim) {
    for (var i = 0; i < victim.length; i++) {
      markerVictim.add(new Marker(
          height: 30,
          width: 30,
          point: LatLng(victim.elementAt(i).location.latitude,
              victim.elementAt(i).location.longitude),
          builder: (ctx) => new IconButton(
                onPressed: () {
                  _animatedMapMove(
                      LatLng(victim.elementAt(i).location.latitude,
                          victim.elementAt(i).location.longitude),
                      17);
                  detailBottomSheet(victim.elementAt(i));
                },
                icon: Icon(
                  Icons.flag,
                  color: Colors.red,
                ),
              )));
    }
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
            zoom: 12,
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
            MarkerClusterLayerOptions(
              showPolygon: false,
              maxClusterRadius: 100,
              size: Size(40, 40),
              fitBoundsOptions: FitBoundsOptions(
                padding: EdgeInsets.all(50),
              ),
              markers: markerVictim,
              builder: (context, markers) {
                return Container(
                    decoration: BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: Icon(
                      Icons.flag,
                      color: Colors.white,
                    ));
              },
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
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        child: Icon(Icons.flip_to_back),
        backgroundColor: Colors.red,
        onPressed: () {
          _animatedMapMove(
              LatLng(userLocation.latitude, userLocation.longitude), 3);
        },
      ),
    );
  }
}
