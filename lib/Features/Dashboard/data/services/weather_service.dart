import 'dart:convert';
import 'package:agriculture_app/Features/Dashboard/data/models/today_weather.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = 'eafd94ccabe55535cbc95611f5427646';

  Future<TodayWeather> fetchTodayWeather({
    required double lat,
    required double lon,
  }) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather'
        '?lat=$lat&lon=$lon&units=metric&lang=ar&appid=$_apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return TodayWeather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
