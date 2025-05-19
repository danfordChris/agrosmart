import 'dart:io';
import 'package:agrosmart/models/crop_diseases_model.dart';
import 'package:agrosmart/provider/disease_detection_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class ResultsScreen extends StatefulWidget {
  final File imageFile;

  const ResultsScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  void initState() {
    super.initState();
    // Process the image when the screen initializes
    Future.microtask(() {
      final provider = Provider.of<DiseaseDetectionProvider>(context, listen: false);
      provider.processImage(widget.imageFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Consumer<DiseaseDetectionProvider>(
        builder: (context, provider, child) {
          switch (provider.state) {
            case DetectionState.processing:
              return _buildProcessingUI();
            case DetectionState.resultReady:
              return _buildResultsUI(provider.result!);
            case DetectionState.error:
              return _buildErrorUI(provider.errorMessage!);
            default:
              return _buildProcessingUI();
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green.shade700,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: const Text('New Scan', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Provider.of<DiseaseDetectionProvider>(context, listen: false).reset();
                  Navigator.of(context).pop();
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.history, color: Colors.white),
                label: const Text('View History', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  // Navigate to history screen (not implemented in this example)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('History feature coming soon')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProcessingUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                widget.imageFile,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 30),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          const SizedBox(height: 20),
          Text(
            'Analyzing your crop...',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          const Text(
            'Our AI is identifying any potential diseases',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsUI(CropDiseaseResult result) {
    final dateFormat = DateFormat('MMM d, yyyy - h:mm a');
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 200,
                    child: Image.file(
                      widget.imageFile,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              result.isHealthy ? 'Healthy Plant' : 'Disease Detected',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: result.isHealthy ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              result.isHealthy ? Icons.check_circle : Icons.warning,
                              color: result.isHealthy ? Colors.green : Colors.red,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Scan completed on ${dateFormat.format(result.scannedAt)}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (result.isHealthy)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good News!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Your plant appears to be healthy. Continue with your current care routine.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Disease Information',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  ...result.diseases.map((disease) => _buildDiseaseCard(disease)).toList(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseCard(CropDisease disease) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    disease.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getConfidenceColor(disease.confidence),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(disease.confidence * 100).toStringAsFixed(0)}% Confidence',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(disease.description),
            const SizedBox(height: 16),
            const Text(
              'Treatment Suggestions:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(disease.treatmentSuggestion),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.info_outline),
              label: const Text('Learn More'),
              onPressed: () {
                // Navigate to detailed information page (not implemented)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Detailed information about ${disease.name} coming soon')),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) {
      return Colors.red;
    } else if (confidence >= 0.6) {
      return Colors.orange;
    } else {
      return Colors.amber;
    }
  }

  Widget _buildErrorUI(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red,
          ),
          const SizedBox(height: 20),
          Text(
            'Error Analyzing Image',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              message,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Provider.of<DiseaseDetectionProvider>(context, listen: false).reset();
              Navigator.of(context).pop();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}