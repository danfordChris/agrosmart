import 'package:flutter/material.dart';

class LearningCenterScreen extends StatelessWidget {
  LearningCenterScreen({super.key});

  final List<LearningCard> learningCards = [
    LearningCard(
      title: 'Crop Detection',
      description: 'Learn how to detect crops using AI.',
      imagePath: 'assets/images/maize.png',
      color: Colors.green,
    ),
    LearningCard(
      title: 'Disease Detection',
      description: 'Learn how to detect diseases in crops.',
      imagePath: 'assets/images/maize.png',
      color: Colors.red,
    ),
    LearningCard(
      title: 'Weather Prediction',
      description: 'Learn how to predict weather conditions for farming.',
      imagePath: 'assets/images/maize.png',
      color: Colors.blue,
    ),
    LearningCard(
      title: 'Soil Analysis',
      description: 'Learn how to analyze soil quality for better yield.',
      imagePath: 'assets/images/maize.png',
      color: Colors.brown,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Learning Center'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: _calculateChildAspectRatio(context),
            ),
            itemCount: learningCards.length,
            itemBuilder: (context, index) {
              return _buildLearningCard(context, learningCards[index]);
            },
          ),
        ),
      ),
    );
  }

  double _calculateChildAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Adjust aspect ratio based on screen width
    return screenWidth < 400 ? 0.75 : 0.85;
  }

  Widget _buildLearningCard(BuildContext context, LearningCard card) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LearningDetailScreen(card: card),
              ),
            );
          },
          child: Container(
            constraints: BoxConstraints(
              minHeight: constraints.maxWidth * 1.2, // Ensure minimum height
            ),
            decoration: BoxDecoration(
              color: card.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(color: card.color.withOpacity(0.5), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        card.imagePath,
                        // 'assets/images/maize.png',
                        width: double.infinity,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 24, // Fixed height for title
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            card.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: card.color,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 32, // Fixed height for description
                        child: Text(
                          card.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 36, // Fixed button height
                    child: ElevatedButton(
                      onPressed: () {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text('Starting ${card.title}...'),
                        //     backgroundColor: card.color,
                        //   ),
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => LearningDetailScreen(card: card),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: card.color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Learn Now',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class LearningCard {
  final String title;
  final String description;
  final String imagePath;
  final Color color;

  LearningCard({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.color,
  });
}

class LearningDetailScreen extends StatelessWidget {
  final LearningCard card;

  const LearningDetailScreen({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card.title),
        backgroundColor: card.color.withOpacity(0.2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: card.title,
              child: Image.asset(
                card.imagePath,
                width: double.infinity,

                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              card.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: card.color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              card.description,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What You Will Learn:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildFeatureItem('Step-by-step tutorials'),
                  _buildFeatureItem('Interactive examples'),
                  _buildFeatureItem('Practical applications'),
                  _buildFeatureItem('Expert tips and tricks'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Start learning action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: card.color,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Start Learning',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: card.color),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
