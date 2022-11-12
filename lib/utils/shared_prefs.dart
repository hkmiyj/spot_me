import 'package:mapbox_gl/mapbox_gl.dart';
import '../main.dart';

LatLng getCurrentLatLngFromSharedPrefs() {
  return LatLng(sharedPreferences.getDouble('latitude')!,
      sharedPreferences.getDouble('longitude')!);
}
