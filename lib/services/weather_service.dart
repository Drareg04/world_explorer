import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const String baseUrl = 'https://api.open-meteo.com/v1';

  static Future<Weather> fetchCurrentWeather(double lat, double lon) async {
    final url = Uri.parse(
        '$baseUrl/forecast?latitude=$lat&longitude=$lon&current_weather=true');
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}