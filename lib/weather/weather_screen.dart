import 'package:agrosmart/weather/city_model.dart';
import 'package:agrosmart/weather/city_search_field.dart';
import 'package:agrosmart/weather/loading_widget.dart';
import 'package:agrosmart/weather/location_service.dart';
import 'package:agrosmart/weather/weather_card.dart';
import 'package:agrosmart/weather/weather_model.dart';
import 'package:agrosmart/weather/weather_service.dart';
import 'package:flutter/material.dart';

class WeatherScreen1 extends StatefulWidget {
  final WeatherService weatherService;
  final LocationService locationService;

  const WeatherScreen1({
    Key? key,
    required this.weatherService,
    required this.locationService,
  }) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen1> {
  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _fetchWeatherByLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final position = await widget.locationService.getCurrentLocation();
      if (position != null) {
        final weather = await widget.weatherService.getWeatherByLocation(
          position.latitude,
          position.longitude,
        );
        setState(() {
          _weatherData = weather;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Location permission denied or unavailable';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to get location weather: $e';
      });
    }
  }

  Future<void> _fetchWeatherByCity(City city) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await widget.weatherService.getWeatherByLocation(
        city.lat,
        city.lon,
      );
      setState(() {
        _weatherData = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to get city weather: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeatherByLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tanzania Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _fetchWeatherByLocation,
            tooltip: 'Get current location weather',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CitySearchField(
              onSearch: widget.weatherService.searchCities,
              onCitySelected: _fetchWeatherByCity,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const LoadingWidget()
            else if (_errorMessage != null)
              Column(
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  TextButton(
                    onPressed: _fetchWeatherByLocation,
                    child: const Text('Retry'),
                  ),
                ],
              )
            else if (_weatherData != null)
              // WeatherCard(weather: _weatherData!)
              Container()
            else
              const Center(
                child: Text(
                  'Search for a city in Tanzania or use your current location',
                  style: TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
