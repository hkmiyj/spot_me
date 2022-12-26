import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:spot_me/model/userLocation.dart';
import 'package:spot_me/model/victims.dart';
import 'package:spot_me/widget/showMap.dart';
import 'package:intl/intl.dart';

class locatePage extends StatefulWidget {
  const locatePage({super.key});

  @override
  State<locatePage> createState() => _locatePageState();
}

class _locatePageState extends State<locatePage> {
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

  bottomSheetBar() {
    final _victim = Provider.of<List<Victim>>(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.09,
      maxChildSize: 0.45,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: Colors.white,
          child: ListView.builder(
            controller: scrollController,
            itemCount: _victim.length,
            itemBuilder: ((context, index) {
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
                      Text(calcTime(_victim.elementAt(index).time.toDate())),
                      Text(_victim.elementAt(index).description),
                    ],
                  ),
                  trailing: Text(calcDistance(LatLng(
                      _victim.elementAt(index).location.latitude,
                      _victim.elementAt(index).location.longitude))));
            }),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Locate Victim'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Map(
              context,
            ),
            bottomSheetBar()
          ],
        ));
  }
}
