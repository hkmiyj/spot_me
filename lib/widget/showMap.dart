import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:spot_me/model/shelter.dart';
import 'package:spot_me/model/userLocation.dart';
import 'package:spot_me/utils/const.dart';
import 'package:flutter_map_dragmarker/dragmarker.dart';
import 'package:flutter_map_dragmarker/main.dart';

addmarker(shelters, markerVictim) {
  for (var i = 0; i < shelters.length; i++) {
    final shelter = shelters[i];
    markerVictim.add(new Marker(
      height: 30,
      width: 30,
      point: LatLng(shelter.location.latitude, shelter.location.longitude),
      builder: (ctx) => Icon(
        Icons.flag,
        color: Colors.red,
      ),
    ));
  }
}

showMap(context) {
  List<Marker> markerVictim = [];
  var userLocation = Provider.of<UserLocation>(context);
  var _shelter = Provider.of<List<Shelter>>(context, listen: false);
  addmarker(_shelter, markerVictim);

  return FlutterMap(
    options: MapOptions(
      center: LatLng(userLocation.latitude, userLocation.longitude),
      zoom: 12,
      slideOnBoundaries: false,
      interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
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
      //CircleLayerOptions(circles: circleMarkers),

      MarkerClusterLayerOptions(
        showPolygon: false,
        maxClusterRadius: 1,
        size: Size(40, 40),
        fitBoundsOptions: FitBoundsOptions(
          padding: EdgeInsets.all(50),
        ),
        markers: markerVictim,
        builder: (context, markers) {
          return Container(
              decoration:
                  BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: Icon(
                Icons.flag,
                color: Colors.white,
              ));
        },
      ),
      LocationMarkerLayerOptions(headingStream: Stream.empty()),
    ],
    nonRotatedChildren: [],
  );
}
