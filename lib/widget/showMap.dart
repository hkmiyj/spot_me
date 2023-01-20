import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:spot_me/model/userLocation.dart';
import 'package:spot_me/utils/const.dart';
import 'package:flutter_map_dragmarker/dragmarker.dart';
import 'package:flutter_map_dragmarker/main.dart';

showMap(context) {
  var userLocation = Provider.of<UserLocation>(context);
  final circleMarkers = <CircleMarker>[
    CircleMarker(
        point: LatLng(userLocation.latitude, userLocation.longitude),
        color: Colors.blue.withOpacity(0.3),
        borderStrokeWidth: 2,
        borderColor: Colors.blue.withOpacity(0.4),
        useRadiusInMeter: true,
        radius: 2000 // 2000 meters | 2 km
        ),
  ];
  return FlutterMap(
    options: MapOptions(
      center: LatLng(userLocation.latitude, userLocation.longitude),
      zoom: 12,
      slideOnBoundaries: false,
      interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
      plugins: [LocationMarkerPlugin(), DragMarkerPlugin()],
    ),
    children: [],
    layers: [
      TileLayerOptions(
        urlTemplate:
            "https://api.mapbox.com/styles/v1/damfud/cl7n4wktc001v16lnqcz7i2z8/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZGFtZnVkIiwiYSI6ImNsN2s3dHNoMzBmOWIzb3F6OWkyMnM0ZWoifQ.N022hvg6-KtFSQ7NqetikQ",
        additionalOptions: {"access_token": mapPk_AccessToken},
      ),
      CircleLayerOptions(circles: circleMarkers),
      LocationMarkerLayerOptions(headingStream: Stream.empty()),
    ],
    nonRotatedChildren: [],
  );
}
