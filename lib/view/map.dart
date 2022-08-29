import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

//scrcpy
class map extends StatefulWidget {
  const map({Key? key}) : super(key: key);

  @override
  State<map> createState() => _mapState();
}

class _mapState extends State<map> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        plugins: [
          LocationMarkerPlugin(), // <-- add plugin here
        ],
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:
              'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        LocationMarkerLayerOptions(), // <-- add layer options here
      ],
    );
  }
}
