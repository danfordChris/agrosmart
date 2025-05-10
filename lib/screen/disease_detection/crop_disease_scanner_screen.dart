import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CropDiseaseScannerScreen extends StatefulWidget {
  const CropDiseaseScannerScreen({Key? key}) : super(key: key);

  @override
  _CropDiseaseScannerScreenState createState() =>
      _CropDiseaseScannerScreenState();
}

class _CropDiseaseScannerScreenState extends State<CropDiseaseScannerScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isProcessing = false;
  bool _isCameraInitialized = false;
  File? _capturedImage;

  // Sample data to simulate AI model results
  final Map<String, dynamic> _sampleResults = {
    'disease': 'Late Blight',
    'confidence': 0.92,
    'recommendations': [
      'Apply fungicides like chlorothalonil.',
      'Remove and destroy affected leaves.',
      'Ensure proper crop rotation.',
    ],
  };

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _showErrorSnackbar('No cameras available');
        return;
      }

      _controller = CameraController(
        cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first,
        ),
        ResolutionPreset.high,
        enableAudio: false,
      );

      _initializeControllerFuture = _controller!.initialize().then((_) {
        if (!mounted) return;
        setState(() => _isCameraInitialized = true);
      });

      await _initializeControllerFuture;
    } on CameraException catch (e) {
      _showErrorSnackbar('Camera error: ${e.description}');
    } catch (e) {
      _showErrorSnackbar('Error initializing camera: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    print(message);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(message),
    //     duration: const Duration(seconds: 4),
    //   ),
    // );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    if (!_isCameraInitialized || _isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final image = await _controller!.takePicture();
      final directory = await getTemporaryDirectory();
      final imagePath = join(
        directory.path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final savedImage = await File(image.path).copy(imagePath);

      // Simulate AI processing
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() => _capturedImage = savedImage);
      _showResults(_sampleResults);
    } on CameraException catch (e) {
      _showErrorSnackbar('Camera error: ${e.description}');
    } catch (e) {
      _showErrorSnackbar('Error capturing image: $e');
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showResults(Map<String, dynamic> results) {
    showDialog(
      context: this.context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Crop Disease Detection',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_capturedImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _capturedImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 16),
                  _buildResultItem('Disease', results['disease']),
                  _buildResultItem(
                    'Confidence',
                    '${(results['confidence'] * 100).toStringAsFixed(1)}%',
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Recommendations:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  ...results['recommendations']
                      .map<Widget>(
                        (rec) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '• $rec',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() => _capturedImage = null);
                },
                child: const Text('OK', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
    );
  }

  Widget _buildResultItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 15),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Disease Scanner'),
        centerTitle: true,
      ),
      body: _buildCameraContent(),
    );
  }

  Widget _buildCameraContent() {
    if (!_isCameraInitialized) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Initializing camera...'),
          ],
        ),
      );
    }

    return Stack(
      children: [
        CameraPreview(_controller!),
        if (_isProcessing)
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        _buildCaptureButton(),
      ],
    );
  }

  Widget _buildCaptureButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: FloatingActionButton.large(
          onPressed: _isProcessing ? null : _captureImage,
          backgroundColor: _isProcessing ? Colors.grey : Colors.green,
          child: Icon(
            _isProcessing ? Icons.hourglass_top : Icons.camera_alt,
            size: 36,
          ),
        ),
      ),
    );
  }
}
