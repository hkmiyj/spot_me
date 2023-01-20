import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:spot_me/model/shelter.dart';
import 'package:spot_me/model/userLocation.dart';
import 'package:spot_me/service/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart';

class shelterList extends StatefulWidget {
  const shelterList({super.key});

  @override
  State<shelterList> createState() => _shelterListState();
}

class _shelterListState extends State<shelterList> {
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
      return distanceDiff.toStringAsFixed(2) + " " + "Kilometer";
    } else
      return _distanceInMeters.toInt().toString() + " " + "Meter";
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

  @override
  Widget build(BuildContext context) {
    final _shelters = Provider.of<List<Shelter>>(context);
    //print(_shelters.first.location);

    if (_shelters == []) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Shelter'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                        ),
                        hintText: 'Search',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Background color
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 138.0),
                        child: Text(
                          "Search",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontFamily: "WorkSansBold"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: _shelters.length,
              itemBuilder: ((context, index) {
                _shelters.sort((a, b) => (calcDistanceDiff(
                        LatLng(a.location.latitude, a.location.longitude)))
                    .compareTo(calcDistanceDiff(
                        LatLng(b.location.latitude, b.location.longitude))));
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.place_rounded,
                        color: Colors.red,
                        size: 45.0,
                      ),
                      title: Text(_shelters.elementAt(index).name),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(calcDistance(LatLng(
                              _shelters.elementAt(index).location.latitude,
                              _shelters.elementAt(index).location.longitude))),
                          Text("Address",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500)),
                          FutureBuilder<String>(
                            future: address(LatLng(
                                _shelters.elementAt(index).location.latitude,
                                _shelters.elementAt(index).location.longitude)),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> address) {
                              if (address.hasData) {
                                return Text('${address.data}');
                              } else {
                                return Text('No address found');
                              }
                            },
                          ),
                        ],
                      ),
                      trailing: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () async {
                                final Uri launchUri = Uri(
                                  scheme: 'tel',
                                  path: _shelters.elementAt(index).phone,
                                );
                                await launchUrl(launchUri);
                              },
                              icon: Icon(
                                Icons.phone,
                                size: 20,
                              )),
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
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text("Choose Map",
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
                                                  coords: Coords(
                                                      _shelters
                                                          .elementAt(index)
                                                          .location
                                                          .latitude,
                                                      _shelters
                                                          .elementAt(index)
                                                          .location
                                                          .longitude),
                                                  title: _shelters
                                                      .elementAt(index)
                                                      .name,
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
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              }),
            )
                /*
              child: ListView(children: <Widget>[
                for (var shelter in _shelters)
                  if (shelter.status == true)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.place_rounded,
                            color: Colors.red,
                            size: 45.0,
                          ),
                          title: Text(shelter.name.toUpperCase(),
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(calcDistance(LatLng(
                                  shelter.location.latitude,
                                  shelter.location.longitude))),
                              //Text(shelter.location.latitude.toString()),
                              //Text(shelter.location.longitude.toString()),
                              SizedBox(
                                height: 3,
                              ),
                              Text("Address",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              FutureBuilder<String>(
                                future: address(LatLng(
                                    shelter.location.latitude,
                                    shelter.location.longitude)),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> address) {
                                  if (address.hasData) {
                                    return Text('${address.data}');
                                  } else {
                                    return Text('No address found');
                                  }
                                },
                              ),

                              /*Text(
                                  "13th College Bus Stop,  Serdang, Selangor 43400, Malaysia",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400))*/
                            ],
                          ),
                          trailing: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    final Uri launchUri = Uri(
                                      scheme: 'tel',
                                      path: shelter.phone,
                                    );
                                    await launchUrl(launchUri);
                                  },
                                  icon: Icon(
                                    Icons.phone,
                                    size: 20,
                                  )),
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
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text("Choose Map",
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
                                                      coords: Coords(
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
                                  ))
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      ),
                    ),
              ]),
            */
                ),
          ],
        ));
  }
}
