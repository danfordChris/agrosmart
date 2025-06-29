import 'package:agrosmart/services/crop_diseases_service.dart';
import 'package:agrosmart/weather/city_model.dart';
import 'package:agrosmart/weather/weather_model.dart';
import 'package:agrosmart/weather/weather_service.dart';
import 'package:agrosmart/weather/location_service.dart';
import 'package:agrosmart/provider/crop_prediction_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final LocationService _locationService;
  final CropPredictionService _cropPredictionService;
  final CropPredictionProvider _cropPredictionProvider;

  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;
  Position? _currentPosition;
  String _temperatureUnit = '°C';
  double? _latitude;
  double? _longitude;

  // Getters
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  WeatherData? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Position? get currentPosition => _currentPosition;
  String get temperatureUnit => _temperatureUnit;

  WeatherProvider({
    required WeatherService weatherService,
    required LocationService locationService,
    required CropPredictionService cropPredictionService,
    required CropPredictionProvider cropPredictionProvider,
  }) : _weatherService = weatherService,
       _locationService = locationService,
       _cropPredictionService = cropPredictionService,
       _cropPredictionProvider = cropPredictionProvider {
    print('WeatherProvider initialized');
    _initialize();
  }

  Future<void> _initialize() async {
    print('Initializing WeatherProvider...');
    await fetchWeatherByLocation();
  }

  // Standalone crop prediction function
  Future<void> fetchCropPredictions({
    double? customLat,
    double? customLon,
  }) async {
    print('[fetchCropPredictions] Starting crop prediction fetch');
    // Not setting global loading state anymore, using CropPredictionProvider's loading state instead

    try {
      // Use custom coordinates if provided, otherwise use stored coordinates
      final lat = customLat ?? _latitude;
      final lon = customLon ?? _longitude;

      if (lat == null || lon == null) {
        throw Exception('No coordinates available for prediction');
      }

      print('[fetchCropPredictions] Using coordinates: $lat,$lon');
      await _cropPredictionProvider.fetchPredictions(lat, lon);
      print('[fetchCropPredictions] Completed successfully');
    } catch (e) {
      print('[fetchCropPredictions] Error: $e');
      _setError('Failed to fetch crop predictions: ${e.toString()}');
      // Clear error after a short delay to not disrupt the UI
      Future.delayed(const Duration(seconds: 3), () {
        clearError();
      });
    }
  }

  Future<void> fetchWeatherByLocation() async {
    print('[fetchWeatherByLocation] Starting location-based weather fetch');
    _setLoading(true);

    try {
      final position = await _locationService.getCurrentLocation();
      print('[fetchWeatherByLocation] Got position: $position');

      if (position != null) {
        _latitude = position.latitude;
        _longitude = position.longitude;
        print(
          '[fetchWeatherByLocation] Setting coordinates: $_latitude, $_longitude',
        );

        await _fetchWeatherData(
          latitude: position.latitude,
          longitude: position.longitude,
          position: position,
        );
      } else {
        print(
          '[fetchWeatherByLocation] Position is null - permission likely denied',
        );
        _setError('Location permission denied or unavailable');
      }
    } catch (e) {
      print('[fetchWeatherByLocation] Error: $e');
      _setError('Failed to get location weather: ${e.toString()}');
    }
  }

  Future<void> fetchWeatherByCity(City city) async {
    print('[fetchWeatherByCity] Fetching weather for city: ${city.name}');
    _setLoading(true);

    try {
      _latitude = city.lat;
      _longitude = city.lon;
      print(
        '[fetchWeatherByCity] Setting coordinates: $_latitude, $_longitude',
      );

      await _fetchWeatherData(
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
      print('[fetchWeatherByCity] Error: $e');
      _setError('Failed to get city weather: ${e.toString()}');
    }
  }

  Future<void> fetchWeatherByLatLng(LatLng position) async {
    print('[fetchWeatherByLatLng] Fetching weather for position: $position');
    _setLoading(true);

    try {
      _latitude = position.latitude;
      _longitude = position.longitude;
      print(
        '[fetchWeatherByLatLng] Setting coordinates: $_latitude, $_longitude',
      );

      await _fetchWeatherData(
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
      print('[fetchWeatherByLatLng] Error: $e');
      _setError('Failed to get weather for selected location: ${e.toString()}');
    }
  }

  Future<void> _fetchWeatherData({
    required double latitude,
    required double longitude,
    Position? position,
  }) async {
    print(
      '[_fetchWeatherData] Starting weather fetch for $latitude,$longitude',
    );

    try {
      print('[_fetchWeatherData] Fetching weather data...');
      final weather = await _weatherService.getWeatherByLocation(
        latitude,
        longitude,
      );
      print('[_fetchWeatherData] Weather data received: $weather');

      if (position != null) {
        print('[_fetchWeatherData] Updating position to $position');
        _currentPosition = position;
      }

      _setWeatherData(weather);
    } catch (e) {
      print('[_fetchWeatherData] Error: $e');
      _setError('Failed to fetch weather data: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<City>> searchCities(String query) async {
    print('[searchCities] Searching for: $query');
    if (query.isEmpty) {
      print('[searchCities] Empty query - returning empty list');
      return [];
    }

    try {
      final cities = await _weatherService.searchCities(query);
      print('[searchCities] Found ${cities.length} cities');
      return cities;
    } catch (e) {
      print('[searchCities] Error: $e');
      _setError('Failed to search cities: ${e.toString()}');
      return [];
    }
  }

  Future<void> updatePosition(LatLng position) async {
    print('[updatePosition] Updating to position: $position');
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
      _latitude = position.latitude;
      _longitude = position.longitude;
      print('[updatePosition] Updated coordinates: $_latitude,$_longitude');

      notifyListeners();
      await fetchWeatherByLatLng(position);
    } catch (e) {
      print('[updatePosition] Error: $e');
      _setError('Failed to update position: ${e.toString()}');
    }
  }

  void toggleTemperatureUnit() {
    _temperatureUnit = _temperatureUnit == '°C' ? '°F' : '°C';
    print('[toggleTemperatureUnit] Switched to $_temperatureUnit');
    notifyListeners();
  }

  double? getDisplayTemperature() {
    if (_weatherData == null) {
      print('[getDisplayTemperature] No weather data available');
      return null;
    }

    final temp =
        _temperatureUnit == '°C'
            ? _weatherData!.temperature
            : (_weatherData!.temperature * 9 / 5) + 32;

    print(
      '[getDisplayTemperature] Converted ${_weatherData!.temperature}°C to $temp$_temperatureUnit',
    );
    return temp;
  }

  void _setLoading(bool value) {
    print('[setLoading] Setting loading state to $value');
    _isLoading = value;
    notifyListeners();
  }

  void _setWeatherData(WeatherData weather) {
    print('[setWeatherData] Setting new weather data: $weather');
    _weatherData = weather;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    print('[setError] Setting error message: $message');
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    print('[clearError] Clearing error message');
    _errorMessage = null;
    notifyListeners();
  }
}
