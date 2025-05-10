import 'package:agrosmart/Constants/app_colors.dart';
import 'package:agrosmart/components/expanded_button.dart';
import 'package:agrosmart/provider/weather_provider.dart';
import 'package:agrosmart/screen/arlert_screen.dart';
import 'package:agrosmart/screen/chartbot_screen.dart';
import 'package:agrosmart/screen/disease_detection/camera_screen.dart';
import 'package:agrosmart/screen/disease_detection/crop_disease_scanner_screen.dart';
import 'package:agrosmart/screen/market_place.dart';
import 'package:agrosmart/screen/user_account_screen.dart';
import 'package:agrosmart/screen/weather_screen.dart';
import 'package:agrosmart/weather/weather_screen.dart';
import 'package:agrosmart/weather/weather_service.dart';
import 'package:agrosmart/weather/location_service.dart';
import 'package:agrosmart/weather/weather_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AgroSmartHome(),
      ),
    );
  }
}

class AgroSmartHome extends StatefulWidget {
  const AgroSmartHome({super.key});

  @override
  _AgroSmartHomeState createState() => _AgroSmartHomeState();
}

class _AgroSmartHomeState extends State<AgroSmartHome> {
  int _selectedIndex = 0;

  // List of pages for navigation
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const WeatherScreen(),
      // const MessagesPage(),
      AgriChatbotScreen(),
      const AlertsPage(),
      // CameraScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Agro',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'Smart',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                // Handle profile icon tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserAccountScreen(),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey.shade500,
        selectedLabelStyle: const TextStyle(fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color:
                    _selectedIndex == 0
                        ? Colors.green.shade100
                        : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.home, size: 20),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color:
                    _selectedIndex == 1
                        ? Colors.green.shade100
                        : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.place, size: 20),
            ),
            label: "Weather",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color:
                    _selectedIndex == 2
                        ? Colors.green.shade100
                        : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.message, size: 20),
            ),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color:
                    _selectedIndex == 3
                        ? Colors.green.shade100
                        : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications, size: 20),
            ),
            label: "Alerts",
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Consumer<WeatherProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return SizedBox.shrink();
                } else if (provider.errorMessage != null) {
                  return Column(
                    children: [
                      Text(
                        provider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      TextButton(
                        onPressed: () {
                          provider.fetchWeatherByLocation();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  );
                } else {
                  return const WeatherCard();
                }
              },
            ),
            const SizedBox(height: 20),
            _buildMarketButton(context),
            const SizedBox(height: 20),
            const Text(
              "Main Features",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFeatureCards(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MarketplaceScreen()),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.green.shade50,
          border: Border.all(color: AppColors.secondary, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withAlpha(25),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.eco, color: Colors.green.shade800),
                ),
                const SizedBox(width: 12),
                Text(
                  "Ingia Sokoni",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward, color: Colors.green.shade800),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCards(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildFeatureCard(
              context,
              Icons.health_and_safety,
              "Tambua ugonjwa unaoshambulia",
              "Tambua Magonjwa",
              const CameraScreen(),
            ),
            const SizedBox(width: 12),
            _buildFeatureCard(
              context,
              Icons.agriculture,
              "Pata ushauri wa zao la kilimo",
              "Ushauri wa mazao",
              const AgriChatbotScreen(),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildFeatureCard(
              context,
              Icons.insights,
              "Fuatilia mavuno yako",
              "Fuatilia mavuno",
              const MarketplaceScreen(),
            ),
            const SizedBox(width: 12),
            _buildFeatureCard(
              context,
              Icons.water_drop,
              "Usimamizi wa umwagiliaji",
              "Usimamizi wa maji",
              const WeatherScreen(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String buttonText,
    Widget destination,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.green.shade50,
            border: Border.all(color: AppColors.secondary, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withAlpha(12),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: Colors.green.shade800),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.green.shade900,
                ),
              ),
              const SizedBox(height: 12),
              ExpandedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => destination),
                  );
                },
                text: buttonText,
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                borderRadius: 12,
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
