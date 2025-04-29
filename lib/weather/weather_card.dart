import 'package:agrosmart/Constants/app_colors.dart';
import 'package:agrosmart/provider/weather_provider.dart';
import 'package:agrosmart/weather/weather_model.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        final weather = provider.weatherData;
        if (weather == null) {
          return const SizedBox.shrink();
        }
        return _buildWeatherCard(context, weather);
      },
    );
  }

  Widget _buildWeatherCard(BuildContext context, WeatherData weather) {
    // Helper function to get weather icon based on condition
    IconData _getWeatherIcon(String condition) {
      switch (condition.toLowerCase()) {
        case 'clear':
          return Icons.wb_sunny;
        case 'clouds':
          return Icons.cloud;
        case 'rain':
          return Icons.umbrella;
        case 'thunderstorm':
          return Icons.flash_on;
        default:
          return Icons.wb_cloudy;
      }
    }

    // Use temperature, max, and min from WeatherData (assuming metric units from WeatherService)
    final tempCelsius = weather.temperature;
    final tempHighCelsius = weather.temperature;
    final tempLowCelsius = weather.temperature;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            AppColors.primary, // Using AppColors.primary
            Colors.green[700]!, // Tanzanian green
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(76),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Temperature and weather icon row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${tempCelsius.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'H: ${tempHighCelsius.toStringAsFixed(1)}°C  L: ${tempLowCelsius.toStringAsFixed(1)}°C',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withAlpha(230),
                    ),
                  ),
                ],
              ),
              Icon(
                _getWeatherIcon(weather.mainCondition),
                size: 60,
                color: Colors.white.withAlpha(204),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Location and date
          Text(
            '${weather.cityName.isEmpty ? 'Unknown' : weather.cityName}, ${DateFormat('MMM d').format(weather.date)}',
            style: TextStyle(fontSize: 16, color: Colors.white.withAlpha(230)),
          ),
          const SizedBox(height: 8),

          // Weather details row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildWeatherDetail(
                'Humidity',
                '${weather.humidity}%',
                Icons.water_drop,
              ),
              _buildWeatherDetail(
                'Wind',
                '${weather.windSpeed} km/h',
                Icons.air,
              ),
              _buildWeatherDetail(
                'Pressure',
                '${weather.pressure} hPa',
                Icons.speed,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Weather condition tag
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                weather.mainCondition.isEmpty
                    ? 'Unknown'
                    : weather.mainCondition,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: Colors.white.withAlpha(230)),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withAlpha(230),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
