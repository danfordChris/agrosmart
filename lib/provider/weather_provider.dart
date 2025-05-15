import 'package:agrosmart/weather/city_model.dart';
import 'package:agrosmart/weather/weather_model.dart';
import 'package:agrosmart/weather/weather_service.dart';
import 'package:agrosmart/weather/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../services/crop_diseases_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final LocationService _locationService;

  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;
  Position? _currentPosition;

  WeatherData? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Position? get currentPosition => _currentPosition;

  WeatherProvider({
    required WeatherService weatherService,
    required LocationService locationService,
  }) : _weatherService = weatherService,
       _locationService = locationService {
    fetchWeatherByLocation();
  }

  Future<void> fetchWeatherByLocation() async {
    _setLoading(true);

    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        _currentPosition = position;
        final weather = await _weatherService.getWeatherByLocation(
          position.latitude,
          position.longitude,
        );

        final payload = {
          "latitude": position.latitude,
          "longitude": position.longitude,
        };

        //await cropPredictionService.getpredictedCrops(payload);

        _setWeatherData(weather);
      } else {
        _setError('Location permission denied or unavailable');
      }
    } catch (e) {
      _setError('Failed to get location weather: $e');
    }
  }

  Future<void> fetchWeatherByCity(City city) async {
    _setLoading(true);

    try {
      final weather = await _weatherService.getWeatherByLocation(
        city.lat,
        city.lon,
      );
      _currentPosition = Position(
        latitude: city.lat,
        longitude: city.lon,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0.0, // Added required parameter
        headingAccuracy: 0,
      );
      _setWeatherData(weather);
      final payload = {"latitude": city.lat, "longitude": city.lon};

      //await cropPredictionService.getpredictedCrops(payload);
    } catch (e) {
      _setError('Failed to get city weather: $e');
    }
  }

  Future<void> fetchWeatherByLatLng(LatLng position) async {
    _setLoading(true);

    try {
      final weather = await _weatherService.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      _currentPosition = Position(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0.0, // Added required parameter
        headingAccuracy: 0,
      );
      _setWeatherData(weather);
      final payload = {
        "latitude": position.latitude,
        "longitude": position.longitude,
      };

      //await cropPredictionService.getpredictedCrops(payload);
    } catch (e) {
      _setError('Failed to get weather for selected location: $e');
    }
  }

  Future<List<City>> searchCities(String query) async {
    try {
      return await _weatherService.searchCities(query);
    } catch (e) {
      _setError('Failed to search cities: $e');
      return [];
    }
  }

  Future<void> updatePosition(LatLng position) async {
    _currentPosition = Position(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0.0, // Added required parameter
      headingAccuracy: 0,
    );
    notifyListeners();
    fetchWeatherByLatLng(position);
    final payload = {
      "latitude": position.latitude,
      "longitude": position.longitude,
    };

    //await cropPredictionService.getpredictedCrops(payload);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setWeatherData(WeatherData weather) {
    _weatherData = weather;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    _weatherData = null;
    notifyListeners();
  }
}
