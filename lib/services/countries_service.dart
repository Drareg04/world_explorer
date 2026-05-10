import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountriesService {
  static const String baseUrl = 'https://restcountries.com/v3.1';

  /// Search country by name (partial match, returns first match)
  static Future<Country> fetchCountryByName(String name) async {
    final url = Uri.parse('$baseUrl/name/$name?fullText=false');
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isEmpty) throw Exception('Country not found');
      return Country.fromJson(data[0]);
    } else if (response.statusCode == 404) {
      throw Exception('Country not found');
    } else {
      throw Exception('Failed to load country data');
    }
  }
}