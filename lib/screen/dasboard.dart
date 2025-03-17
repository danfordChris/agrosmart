import 'package:flutter/material.dart';



class Dasboard extends StatelessWidget {
  const Dasboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AgroSmartHome(),
    );
  }
}

class AgroSmartHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "AgroSmart",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: Icon(Icons.person, color: Colors.black),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWeatherCard(),
              const SizedBox(height: 20),
              _buildMarketButton(),
              const SizedBox(height: 20),
              const Text(
                "Main Features",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildFeatureCards(),

              // Rectangle Widget
              const SizedBox(height: 20),
              const Text(
                "Rectangle Widget",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade200],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "84°F",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "H: 102°F   L: 76°F",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            "Kisaki, Morogoro",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Align(
            alignment: Alignment.bottomRight,
            child: Text("Mawingu", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketButton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.green.shade100,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Row(
            children: [
              Icon(Icons.eco, color: Colors.green),
              SizedBox(width: 10),
              Text(
                "Ingia Sokoni",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Icon(Icons.arrow_forward, color: Colors.green),
        ],
      ),
    );
  }

  Widget _buildFeatureCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                Icons.health_and_safety,
                "Tambua ugonjwa unaoshambulia",
                "Tambua Magonjwa",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildFeatureCard(
                Icons.agriculture,
                "Pata ushauri wa zao la kilimo",
                "Pata ushauri wa mazao",
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                Icons.health_and_safety,
                "Tambua ugonjwa unaoshambulia",
                "Tambua Magonjwa",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildFeatureCard(
                Icons.agriculture,
                "Pata ushauri wa zao la kilimo",
                "Pata ushauri wa mazao",
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                Icons.health_and_safety,
                "Tambua ugonjwa unaoshambulia",
                "Tambua Magonjwa",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildFeatureCard(
                Icons.agriculture,
                "Pata ushauri wa zao la kilimo",
                "Pata ushauri wa mazao",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String buttonText) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.green.shade100,
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.green),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: Text(buttonText),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.place), label: "Location"),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: "Notifications",
        ),
      ],
    );
  }
}

class RectangleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      width: 364,
      height: 185,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFBEE3CB), // Light Green
            Color(0xFF9DD0AF), // Medium Green
            Color(0xFF4BA26A), // Dark Green
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
