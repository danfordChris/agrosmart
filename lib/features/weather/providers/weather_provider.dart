import 'package:agrosmart/services/crop_diseases_service.dart';
import 'package:agrosmart/weather/city_model.dart';
import 'package:agrosmart/weather/weather_model.dart';
import 'package:agrosmart/weather/weather_service.dart';
import 'package:agrosmart/weather/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final LocationService _locationService;
  final CropPredictionService _cropPredictionService;

  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;
  Position? _currentPosition;
  String _temperatureUnit = '°C'; // Default temperature unit

  WeatherData? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Position? get currentPosition => _currentPosition;
  String get temperatureUnit => _temperatureUnit;

  WeatherProvider({
    required WeatherService weatherService,
    required LocationService locationService,
    required CropPredictionService cropPredictionService,
  }) : _weatherService = weatherService,
       _locationService = locationService,
       _cropPredictionService = cropPredictionService {
    _initialize();
  }

  Future<void> _initialize() async {
    await fetchWeatherByLocation();
  }

  Future<void> fetchWeatherByLocation() async {
    _setLoading(true);

    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        await _fetchWeatherAndCropData(
          latitude: position.latitude,
          longitude: position.longitude,
          position: position,
        );
      } else {
        _setError('Location permission denied or unavailable');
      }
    } catch (e) {
      _setError('Failed to get location weather: ${e.toString()}');
    }
  }

  Future<void> fetchWeatherByCity(City city) async {
    _setLoading(true);

    try {
      await _fetchWeatherAndCropData(
        latitude: city.lat,
        longitude: city.lon,
        position: Position(
          latitude: city.lat,
          longitude: city.lon,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0,
        ),
      );
    } catch (e) {
      _setError('Failed to get city weather: ${e.toString()}');
    }
  }

  Future<void> fetchWeatherByLatLng(LatLng position) async {
    _setLoading(true);

    try {
      await _fetchWeatherAndCropData(
        latitude: position.latitude,
        longitude: position.longitude,
        position: Position(
          latitude: position.latitude,
          longitude: position.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0,
        ),
      );
    } catch (e) {
      _setError('Failed to get weather for selected location: ${e.toString()}');
    }
  }

  Future<void> _fetchWeatherAndCropData({
    required double latitude,
    required double longitude,
    Position? position,
  }) async {
    try {
      // Fetch weather data
      final weather = await _weatherService.getWeatherByLocation(
        latitude,
        longitude,
      );

      // Update position if provided
      if (position != null) {
        _currentPosition = position;
      }

      // Set weather data
      _setWeatherData(weather);

      // Fetch crop prediction data
      final payload = {
        "latitude": latitude,
        "longitude": longitude,
  
      };

      // await _cropPredictionService.getpredictedCrops(payload);
    } catch (e) {
      _setError(
        'Failed to complete weather and crop prediction: ${e.toString()}',
      );
      rethrow;
    }
  }

  Future<List<City>> searchCities(String query) async {
    if (query.isEmpty) return [];

    try {
      return await _weatherService.searchCities(query);
    } catch (e) {
      _setError('Failed to search cities: ${e.toString()}');
      return [];
    }
  }

  Future<void> updatePosition(LatLng position) async {
    try {
      _currentPosition = Position(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0,
      );
      notifyListeners();
      await fetchWeatherByLatLng(position);
    } catch (e) {
      _setError('Failed to update position: ${e.toString()}');
    }
  }

  void toggleTemperatureUnit() {
    _temperatureUnit = _temperatureUnit == '°C' ? '°F' : '°C';
    notifyListeners();
  }

  double? getDisplayTemperature() {
    if (_weatherData == null) return null;
    return _temperatureUnit == '°C'
        ? _weatherData!.temperature
        : (_weatherData!.temperature * 9 / 5) + 32;
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
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
