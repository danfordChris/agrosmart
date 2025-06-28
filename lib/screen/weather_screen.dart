import 'package:agrosmart/core/widgets/expanded_button.dart';
import 'package:agrosmart/provider/weather_provider.dart';
import 'package:agrosmart/provider/crop_prediction_provider.dart';
import 'package:agrosmart/weather/city_search_field.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:agrosmart/Constants/app_colors.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late GoogleMapController _mapController;
  bool _mapExpanded = false;
  bool _isMapReady = false;
  List<Map<String, dynamic>> cropSuggestions = [];

  @override
  void initState() {
    super.initState();
    cropSuggestions = _getDefaultCropSuggestions();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cropProvider = Provider.of<CropPredictionProvider>(
        context,
        listen: false,
      );
      _updateCropSuggestions(cropProvider);
      cropProvider.addListener(_onCropProviderChanged);
    });
  }

  @override
  void dispose() {
    final cropProvider = Provider.of<CropPredictionProvider>(
      context,
      listen: false,
    );
    cropProvider.removeListener(_onCropProviderChanged);
    if (_isMapReady) {
      _mapController.dispose();
    }
    super.dispose();
  }

  void _onCropProviderChanged() {
    final cropProvider = Provider.of<CropPredictionProvider>(
      context,
      listen: false,
    );
    _updateCropSuggestions(cropProvider);
  }

  List<Map<String, dynamic>> _getDefaultCropSuggestions() {
    return [
      {
        'name': 'Select a location',
        'description': 'Select a location to get crop recommendations.',
        'idealTemperature': 'N/A',
        'imageUrl': 'assets/images/maize.png',
        'suitability': 'Low',
      },
    ];
  }

  void _updateCropSuggestions(CropPredictionProvider cropProvider) {
    if (!mounted) return;

    setState(() {
      if (cropProvider.isPredictionAvailable) {
        cropSuggestions = [
          {
            'name': cropProvider.predictedCrop,
            'description':
                cropProvider.currentPrediction['explanation'] ??
                'Recommended crop based on soil and weather conditions.',
            'idealTemperature':
                '${cropProvider.temperature?.toStringAsFixed(1) ?? "N/A"}°C',
            'imageUrl': 'assets/images/maize.png',
            'suitability': 'High',
          },
        ];

        if (cropProvider.soilProperties.isNotEmpty) {
          if (cropProvider.soilPH != null && cropProvider.soilPH! > 6.0) {
            cropSuggestions.add({
              'name': 'Rice',
              'description':
                  'Requires abundant water and warm temperatures. Ideal for lowland areas.',
              'idealTemperature': '20°C - 35°C',
              'imageUrl': 'assets/images/rice.png',
              'suitability': 'Medium',
            });
          }

          if (cropProvider.nitrogenLevel != null &&
              cropProvider.nitrogenLevel! > 0.3) {
            cropSuggestions.add({
              'name': 'Wheat',
              'description':
                  'Cool-season crop that needs moderate temperatures and well-drained soil.',
              'idealTemperature': '15°C - 24°C',
              'imageUrl': 'assets/images/wheat.png',
              'suitability': 'Medium',
            });
          }
        }
      } else {
        cropSuggestions = _getDefaultCropSuggestions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Bar
                      SafeArea(
                        child: Row(
                          children: [
                            Expanded(
                              child: CitySearchField(
                                onSearch: provider.searchCities,
                                onCitySelected: provider.fetchWeatherByCity,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Weather Content
                      _buildWeatherContent(context, provider, constraints),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildWeatherContent(
    BuildContext context,
    WeatherProvider provider,
    BoxConstraints constraints,
  ) {
    if (provider.isLoading) {
      return SizedBox(
        height: constraints.maxHeight * 0.7,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.errorMessage != null) {
      return SizedBox(
        height: constraints.maxHeight * 0.7,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                provider.errorMessage!,
                style: const TextStyle(color: AppColors.error),
              ),
              TextButton(
                onPressed: provider.fetchWeatherByLocation,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.weatherData == null) {
      return SizedBox(
        height: constraints.maxHeight * 0.7,
        child: const Center(
          child: Text(
            'Search for a city or use your current location',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Column(
      children: [
        // Weather Summary Card
        // _buildWeatherSummaryCard(provider),

        // Weather Details Grid
        _buildWeatherDetailsGrid(provider),
        const SizedBox(height: 16),

        // Map Section
        _buildMapSection(context, provider, constraints),

        // Crop Suggestions
        const SizedBox(height: 20),
        _buildCropSuggestionsSection(),
      ],
    );
  }

  Widget _buildWeatherSummaryCard(WeatherProvider provider) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        color: AppColors.pureWhite,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat(
                          'EEE, MMM d',
                        ).format(provider.weatherData!.date),
                        style: const TextStyle(
                          color: AppColors.subtext,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${((provider.weatherData!.temperature * 9 / 5) + 32).toStringAsFixed(0)}°',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _getWeatherIcon(provider.weatherData!.mainCondition),
                        size: 40,
                        color: AppColors.warning,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                provider.weatherData!.mainCondition,
                style: const TextStyle(fontSize: 16, color: AppColors.subtext),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetailsGrid(WeatherProvider provider) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      children: [
        _buildDetailCard(
          icon: Icons.air,
          label: 'Wind',
          value: '${provider.weatherData!.windSpeed} m/s',
        ),
        _buildDetailCard(
          icon: Icons.water_drop,
          label: 'Humidity',
          value: '${provider.weatherData!.humidity}%',
        ),
        _buildDetailCard(
          icon: Icons.speed,
          label: 'Pressure',
          value: '${provider.weatherData!.pressure} hPa',
        ),
      ],
    );
  }

  Widget _buildMapSection(
    BuildContext context,
    WeatherProvider provider,
    BoxConstraints constraints,
  ) {
    return Card(
      elevation: 2,
      child: Container(
        color: AppColors.pureWhite,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Location',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.my_location),
                        color: AppColors.greenDark,
                        onPressed: provider.fetchWeatherByLocation,
                      ),
                      IconButton(
                        icon: Icon(
                          _mapExpanded
                              ? Icons.fullscreen_exit
                              : Icons.fullscreen,
                        ),
                        color: AppColors.greenDark,
                        onPressed:
                            () => setState(() => _mapExpanded = !_mapExpanded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height:
                  _mapExpanded
                      ? constraints.maxHeight * 0.5
                      : constraints.maxHeight * 0.3,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target:
                        provider.currentPosition != null
                            ? LatLng(
                              provider.currentPosition!.latitude,
                              provider.currentPosition!.longitude,
                            )
                            : const LatLng(-6.7924, 39.2083),
                    zoom: provider.currentPosition != null ? 14 : 10,
                  ),
                  markers:
                      provider.currentPosition != null
                          ? {
                            Marker(
                              markerId: const MarkerId('currentLocation'),
                              position: LatLng(
                                provider.currentPosition!.latitude,
                                provider.currentPosition!.longitude,
                              ),
                              infoWindow: const InfoWindow(
                                title: 'Your Location',
                              ),
                            ),
                          }
                          : {},
                  onMapCreated: (controller) {
                    setState(() {
                      _mapController = controller;
                      _isMapReady = true;
                      if (provider.currentPosition != null) {
                        controller.animateCamera(
                          CameraUpdate.newLatLng(
                            LatLng(
                              provider.currentPosition!.latitude,
                              provider.currentPosition!.longitude,
                            ),
                          ),
                        );
                      }
                    });
                  },
                  onTap: (position) {
                    provider.updatePosition(position);
                    if (_isMapReady) {
                      _mapController.animateCamera(
                        CameraUpdate.newLatLng(position),
                      );
                    }
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                  mapToolbarEnabled: true,
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    provider.currentPosition != null
                        ? 'Lat: ${provider.currentPosition!.latitude.toStringAsFixed(4)}, '
                            'Lng: ${provider.currentPosition!.longitude.toStringAsFixed(4)}'
                        : 'Tap on map to select location',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                ExpandedButton(
                  onPressed: () async => await provider.fetchCropPredictions(),
                  text: 'Predict Crops',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCropSuggestionsSection() {
    return Card(
      elevation: 2,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Recommended Crops',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: cropSuggestions.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder:
                  (context, index) =>
                      _buildCropListTile(cropSuggestions[index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      elevation: 1,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: Colors.green.shade800),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCropListTile(Map<String, dynamic> crop) {
    return Container(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        leading: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(crop['imageUrl']),
              fit: BoxFit.cover,
              onError: (_, __) => const Icon(Icons.image_not_supported),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                crop['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getSuitabilityColor(crop['suitability']),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${crop['suitability']} Suitability',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(crop['description']),
            const SizedBox(height: 4),
            Text(
              'Ideal Temperature: ${crop['idealTemperature']}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () => _showCropDetails(crop),
      ),
    );
  }

  void _showCropDetails(Map<String, dynamic> crop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.3,
            maxChildSize: 0.85,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: AssetImage(crop['imageUrl']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        crop['name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _getSuitabilityColor(
                            crop['suitability'],
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getSuitabilityColor(crop['suitability']),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: _getSuitabilityColor(crop['suitability']),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${crop['suitability']} Suitability for Current Weather',
                              style: TextStyle(
                                color: _getSuitabilityColor(
                                  crop['suitability'],
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(crop['description']),
                      const SizedBox(height: 16),
                      const Text(
                        'Growing Conditions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.thermostat,
                        'Temperature',
                        crop['idealTemperature'],
                      ),
                      _buildInfoRow(
                        Icons.water_drop,
                        'Water Needs',
                        'Moderate to High',
                      ),
                      _buildInfoRow(Icons.wb_sunny, 'Sunlight', 'Full Sun'),
                      _buildInfoRow(
                        Icons.landscape,
                        'Soil Type',
                        'Well-drained, fertile',
                      ),
                      _buildInfoRow(
                        Icons.calendar_today,
                        'Growing Season',
                        '90-120 days',
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Potential Yield',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Based on your location and current weather conditions, you could expect a ${crop['suitability'].toLowerCase()} yield with proper agricultural practices.',
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Get Growing Guide'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  Color _getSuitabilityColor(String suitability) {
    switch (suitability.toLowerCase()) {
      case 'high':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

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
}
