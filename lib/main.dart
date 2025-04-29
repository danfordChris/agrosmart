import 'package:agrosmart/provider/cart_provider.dart';
import 'package:agrosmart/provider/weather_provider.dart';
import 'package:agrosmart/screen/splash_screen.dart';
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
        ChangeNotifierProvider(
          create:
              (_) => WeatherProvider(
                weatherService: WeatherService(),
                locationService: LocationService(),
              ),
        ),

        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
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
