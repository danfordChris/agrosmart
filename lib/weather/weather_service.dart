import 'dart:convert';
import 'package:agrosmart/weather/city_model.dart';
import 'package:agrosmart/weather/weather_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const String _geocodingUrl = 'http://api.openweathermap.org/geo/1.0/direct';

  Future<List<City>> searchCities(String query) async {
    await dotenv.load(fileName: ".env");
    if (query.isEmpty) return [];

    final response = await http.get(
      Uri.parse('$_geocodingUrl?q=$query&limit=5&appid=${dotenv.env['OPENWEATHER_API_KEY']}&country=TZ'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => City.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load city suggestions');
    }
  }

  Future<WeatherData> getWeatherByLocation(double lat, double lon) async {
    await dotenv.load(fileName: ".env");
    final response = await http.get(
      Uri.parse('$_baseUrl?lat=$lat&lon=$lon&appid=${dotenv.env['OPENWEATHER_API_KEY']}&units=metric'),
    );

    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data for location');
    }
  }
}