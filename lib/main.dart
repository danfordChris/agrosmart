import 'package:agrosmart/provider/auth_provider.dart';
import 'package:agrosmart/provider/cart_provider.dart';
import 'package:agrosmart/provider/crop_detection_provider.dart';
import 'package:agrosmart/provider/crop_prediction_provider.dart';
import 'package:agrosmart/provider/disease_detection_provider.dart';
import 'package:agrosmart/provider/market_products_provider.dart';
import 'package:agrosmart/provider/weather_provider.dart';
import 'package:agrosmart/screen/splash_screen.dart';
import 'package:agrosmart/services/crop_diseases_service.dart';
import 'package:agrosmart/weather/location_service.dart';
import 'package:agrosmart/weather/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CropDetectionProvider(CropDetectionService.instance),
        ),
        ChangeNotifierProvider(create: (_) => MarketProductsProvider()),
        ChangeNotifierProvider(create: (_) => CropPredictionProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(
          create:
              (_) => DiseaseDetectionProvider(CropDetectionService.instance),
        ),
        ChangeNotifierProxyProvider<CropPredictionProvider, WeatherProvider>(
          create:
              (context) => WeatherProvider(
                cropPredictionService: CropPredictionService(),
                weatherService: WeatherService(),
                locationService: LocationService(),
                cropPredictionProvider: Provider.of<CropPredictionProvider>(
                  context,
                  listen: false,
                ),
              ),
          update:
              (context, cropPredictionProvider, previousWeatherProvider) =>
                  previousWeatherProvider ??
                  WeatherProvider(
                    cropPredictionService: CropPredictionService(),
                    weatherService: WeatherService(),
                    locationService: LocationService(),
                    cropPredictionProvider: cropPredictionProvider,
                  ),
        ),
        ChangeNotifierProvider(
          create: (_) => CropDetectionProvider(CropDetectionService.instance),
        ),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Agrosmart',
        theme: ThemeData(),
        home: SplashScreen(),

        // WeatherScreen(
        //   weatherService: WeatherService(),
        //   locationService: LocationService(),
        // ),
      ),
    );
  }
}
