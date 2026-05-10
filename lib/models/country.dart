class Country {
  final String nameCommon;
  final String nameOfficial;
  final String flagUrl;
  final String capital;
  final String region;
  final String subregion;
  final int population;
  final double? lat;
  final double? lon;

  Country({
    required this.nameCommon,
    required this.nameOfficial,
    required this.flagUrl,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.population,
    this.lat,
    this.lon,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    // Extract coordinates from capitalInfo.latlng
    double? lat, lon;
    if (json['capitalInfo'] != null &&
        json['capitalInfo']['latlng'] != null &&
        json['capitalInfo']['latlng'].length == 2) {
      lat = (json['capitalInfo']['latlng'][0] as num?)?.toDouble();
      lon = (json['capitalInfo']['latlng'][1] as num?)?.toDouble();
    }

    return Country(
      nameCommon: json['name']['common'] ?? 'Unknown',
      nameOfficial: json['name']['official'] ?? 'Unknown',
      flagUrl: json['flags']['png'] ?? '',
      capital: (json['capital'] as List?)?.isNotEmpty == true
          ? json['capital'][0]
          : 'No capital',
      region: json['region'] ?? 'Unknown',
      subregion: json['subregion'] ?? 'Unknown',
      population: json['population'] ?? 0,
      lat: lat,
      lon: lon,
    );
  }
}