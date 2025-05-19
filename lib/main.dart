import 'package:agrosmart/provider/auth_provider.dart';
import 'package:agrosmart/provider/cart_provider.dart';
import 'package:agrosmart/provider/crop_prediction_provider.dart';
import 'package:agrosmart/provider/disease_detection_provider.dart';
import 'package:agrosmart/provider/weather_provider.dart';
import 'package:agrosmart/screen/Auth/login_screen.dart';
import 'package:agrosmart/screen/splash_screen.dart';
import 'package:agrosmart/services/crop_diseases_service.dart';
import 'package:agrosmart/weather/location_service.dart';
import 'package:agrosmart/weather/weather_screen.dart';
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
        ChangeNotifierProvider(create: (_) => CropPredictionProvider()),
        ChangeNotifierProvider(
          create: (_) => DiseaseDetectionProvider(CropDetectionService()),
        ),
        ChangeNotifierProvider(
          create:
              (_) => WeatherProvider(
                cropPredictionService: CropPredictionService(),
                weatherService: WeatherService(),
                locationService: LocationService(),
              ),
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Agrosmart',
        theme: ThemeData(),
        home: LoginScreen(),

        // WeatherScreen(
        //   weatherService: WeatherService(),
        //   locationService: LocationService(),
        // ),
      ),
    );
  }
}
