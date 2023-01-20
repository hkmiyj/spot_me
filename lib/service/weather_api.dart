import 'package:weather/weather.dart';

class weatherApi {
  WeatherFactory wf = new WeatherFactory("6091094ec6d3ec6c3fd74e73e84e3ca6");

  Future weather(lat, lon) async {
    Weather w = await wf.currentWeatherByLocation(lat, lon);
  }
}
