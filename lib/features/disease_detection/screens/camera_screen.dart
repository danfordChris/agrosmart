import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  File? _imageFile;
  bool _isLoading = false;
  Map<String, dynamic>? _scanResult;
  bool _showCamera = true;

  // Sample data for demonstration
  final List<Map<String, dynamic>> _sampleDiseases = [
    {
      'name': 'Tomato Early Blight',
      'confidence': 0.85,
      'description': 'A fungal disease that causes concentric rings on leaves.',
      'treatment': 'Remove affected leaves, apply copper-based fungicides.',
      'prevention': 'Rotate crops, ensure proper spacing for air circulation.',
      'severity': 'Moderate',
      'image': 'assets/tomato_blight.jpg', // You can add actual asset paths
    },
    {
      'name': 'Corn Rust',
      'confidence': 0.72,
      'description': 'Reddish-brown pustules on leaves and stems.',
      'treatment': 'Apply fungicides containing chlorothalonil or mancozeb.',
      'prevention': 'Plant resistant varieties, avoid overhead watering.',
      'severity': 'High',
      'image': 'assets/corn_rust.jpg',
    },
    {
      'name': 'Wheat Leaf Spot',
      'confidence': 0.68,
      'description': 'Small, dark brown spots with yellow halos on leaves.',
      'treatment': 'Apply appropriate fungicides early in the season.',
      'prevention': 'Use certified seed, practice crop rotation.',
      'severity': 'Low',
      'image': 'assets/wheat_spot.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(firstCamera, ResolutionPreset.high);

    await _cameraController!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final image = await _cameraController!.takePicture();
      setState(() {
        _imageFile = File(image.path);
        _showCamera = false;
      });

      // Simulate API call with delay
      await Future.delayed(const Duration(seconds: 2));

      // Use random sample data while waiting for real AI model
      final randomIndex = DateTime.now().millisecond % _sampleDiseases.length;
      setState(() {
        _scanResult = _sampleDiseases[randomIndex];
        _isLoading = false;
      });

      // Show results in bottom sheet
      _showResultsBottomSheet();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<void> _pickImageFromGallery() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _showCamera = false;
        });

        // Simulate API call with delay
        await Future.delayed(const Duration(seconds: 2));

        // Use random sample data while waiting for real AI model
        final randomIndex = DateTime.now().millisecond % _sampleDiseases.length;
        setState(() {
          _scanResult = _sampleDiseases[randomIndex];
          _isLoading = false;
        });

        // Show results in bottom sheet
        _showResultsBottomSheet();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void _resetScanner() {
    setState(() {
      _imageFile = null;
      _scanResult = null;
      _showCamera = true;
      _isLoading = false;
    });
  }

  void _showResultsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.85,
            // padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: _buildResultView(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? Container(
                color: Colors.white,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitFadingCircle(color: Colors.green, size: 50.0),
                      SizedBox(height: 20),
                      Text(
                        'Analyzing crop health...',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              )
              : _imageFile != null
              ? _buildImagePreview()
              : _buildCameraView(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          _showCamera
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: 'gallery',
                    onPressed: _pickImageFromGallery,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.photo_library, color: Colors.green),
                  ),
                  const SizedBox(width: 30),
                  FloatingActionButton(
                    heroTag: 'camera',
                    onPressed: _takePicture,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                ],
              )
              : null,
    );
  }

  Widget _buildCameraView() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.green),
        ),
      );
    }

    return Stack(
      children: [
        Positioned.fill(child: CameraPreview(_cameraController!)),
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Point at crop leaves for best results',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        Positioned.fill(child: Image.file(_imageFile!, fit: BoxFit.cover)),
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // Simulate sending to AI model
                setState(() {
                  _isLoading = true;
                });

                Future.delayed(const Duration(seconds: 2), () {
                  // Use random sample data while waiting for real AI model
                  final randomIndex =
                      DateTime.now().millisecond % _sampleDiseases.length;
                  setState(() {
                    _scanResult = _sampleDiseases[randomIndex];
                    _isLoading = false;
                  });
                  _showResultsBottomSheet();
                });
              },
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text(
                'Analyze Image',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
                shadowColor: Colors.green.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Draggable handle
        // Center(
        //   child: Container(
        //     width: 40,
        //     height: 5,
        //     margin: const EdgeInsets.only(bottom: 15),
        //     decoration: BoxDecoration(
        //       color: Colors.grey[300],
        //       borderRadius: BorderRadius.circular(5),
        //     ),
        //   ),
        // ),

        // Image preview
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: FileImage(_imageFile!),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Disease name and confidence
        Row(
          children: [
            Expanded(
              child: Text(
                _scanResult!['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            Chip(
              backgroundColor: _getConfidenceColor(_scanResult!['confidence']),
              label: Text(
                '${(_scanResult!['confidence'] * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        // Severity indicator
        if (_scanResult!.containsKey('severity'))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Severity: ${_scanResult!['severity']}',
                  style: const TextStyle(fontSize: 16, color: Colors.orange),
                ),
              ],
            ),
          ),

        const Divider(height: 30, thickness: 1),

        // Description
        const Text(
          'Description',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          _scanResult!['description'],
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 20),

        // Treatment
        const Text(
          'Recommended Treatment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          _scanResult!['treatment'],
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 20),

        // Prevention
        const Text(
          'Prevention Tips',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          _scanResult!['prevention'],
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 30),

        // Action buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Close'),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetScanner();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Text('Scan Again'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence > 0.8) return Colors.green;
    if (confidence > 0.6) return Colors.orange;
    return Colors.red;
  }
}
