import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/country.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class DetailScreen extends StatefulWidget {
  final Country country;

  const DetailScreen({super.key, required this.country});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _fetchWeather();
  }

  Future<Weather> _fetchWeather() async {
    if (widget.country.lat == null || widget.country.lon == null) {
      throw Exception('No coordinates available for this capital');
    }
    return WeatherService.fetchCurrentWeather(widget.country.lat!, widget.country.lon!);
  }

  String _formatPopulation(int population) {
    return NumberFormat('#,###', 'en_US').format(population);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.country.nameCommon)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flag
            Center(
              child: Image.network(
                widget.country.flagUrl,
                height: 150,
                errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 80),
              ),
            ),
            const SizedBox(height: 16),
            // Country details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.country.nameOfficial,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _detailRow('Capital', widget.country.capital),
                    _detailRow('Region', '${widget.country.region} · ${widget.country.subregion}'),
                    _detailRow('Population', _formatPopulation(widget.country.population)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Weather section
            const Text('Current Weather in Capital',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            FutureBuilder<Weather>(
              future: _weatherFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Weather unavailable: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final weather = snapshot.data!;
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(weather.getWeatherIcon(), size: 48),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${weather.temperature.toStringAsFixed(1)}°C',
                                  style: const TextStyle(fontSize: 24)),
                              Text('Wind: ${weather.windSpeed.toStringAsFixed(1)} km/h'),
                              Text(weather.getWeatherDescription()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}