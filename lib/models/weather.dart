import 'package:flutter/material.dart';

class Weather {
  final double temperature;
  final double windSpeed;
  final int weatherCode;

  Weather({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current_weather'] as Map<String, dynamic>?;
    if (current == null) {
      return Weather(temperature: 0, windSpeed: 0, weatherCode: 0);
    }
    return Weather(
      temperature: (current['temperature'] as num?)?.toDouble() ?? 0,
      windSpeed: (current['windspeed'] as num?)?.toDouble() ?? 0,
      weatherCode: current['weathercode'] ?? 0,
    );
  }

  String getWeatherDescription() {
    switch (weatherCode) {
      case 0:
        return 'Clear sky';
      case 1:
      case 2:
      case 3:
        return 'Partly cloudy';
      case 45:
      case 48:
        return 'Fog';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rain';
      case 71:
      case 73:
      case 75:
        return 'Snow';
      case 95:
        return 'Thunderstorm';
      default:
        return 'Unknown';
    }
  }

  IconData getWeatherIcon() {
    switch (weatherCode) {
      case 0:
        return Icons.wb_sunny;
      case 1:
      case 2:
      case 3:
        return Icons.wb_cloudy;
      case 45:
      case 48:
        return Icons.foggy;
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
        return Icons.grain;
      case 71:
      case 73:
      case 75:
        return Icons.ac_unit;
      case 95:
        return Icons.flash_on;
      default:
        return Icons.help;
    }
  }
}