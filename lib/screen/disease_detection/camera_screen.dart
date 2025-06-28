import 'dart:io';

import 'package:agrosmart/models/crop_diseases_model.dart';
import 'package:agrosmart/provider/crop_detection_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:agrosmart/constants/app_colors.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  bool _showCamera = true;

  @override
  void initState() {
    super.initState();
    print('CameraScreen initState');
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    print('Initializing camera...');
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      print(
        'Found ${cameras.length} cameras. Using first camera: ${firstCamera.name}',
      );

      _cameraController = CameraController(firstCamera, ResolutionPreset.high);
      await _cameraController!.initialize();
      print('Camera initialized successfully');

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    print('Disposing camera controller...');
    _cameraController?.dispose();
    super.dispose();
    print('CameraScreen disposed');
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) {
      print('Camera not initialized - cannot take picture');
      return;
    }

    print('Taking picture...');
    try {
      final image = await _cameraController!.takePicture();
      print('Picture taken at path: ${image.path}');

      final provider = context.read<CropDetectionProvider>();
      await provider.takePicture(File(image.path));

      setState(() => _showCamera = false);
      print('Picture processed and camera hidden');
    } catch (e) {
      print('Error taking picture: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<void> _pickImageFromGallery() async {
    print('Picking image from gallery...');
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        print('Image selected from gallery: ${pickedFile.path}');
        final provider = context.read<CropDetectionProvider>();
        await provider.takePicture(File(pickedFile.path));
        setState(() => _showCamera = false);
        print('Gallery image processed and camera hidden');
      } else {
        print('No image selected from gallery');
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void _showResultsBottomSheet(CropDisease disease) {
    print('Showing results bottom sheet for disease: ${disease.name}');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: _buildResultView(disease),
          ),
    ).whenComplete(() => print('Results bottom sheet closed'));
  }

  @override
  Widget build(BuildContext context) {
    print('Building CameraScreen');

    // Only listen for isLoading changes
    final isLoading = context.select<CropDetectionProvider, bool>(
      (provider) => provider.isLoading,
    );
    print('Current loading state: $isLoading');

    // Get other values without listening
    final provider = context.read<CropDetectionProvider>();
    final imageFile = provider.imageFile;
    final disease = provider.disease;

    return Scaffold(
      body:
          isLoading
              ? _buildLoadingView()
              : imageFile != null
              ? _buildImagePreview(imageFile, provider)
              : _buildCameraView(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _showCamera ? _buildCameraButtons() : null,
    );
  }

  Widget _buildLoadingView() {
    print('Building loading view');
    return Container(
      color: AppColors.pureWhite,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitFadingCircle(color: AppColors.primary, size: 50.0),
            SizedBox(height: 20),
            Text(
              'Analyzing crop health...',
              style: TextStyle(color: AppColors.dark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraView() {
    print('Building camera view');
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print('Camera not ready - showing loading indicator');
      return Container(
        color: AppColors.dark,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
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
                color: AppColors.dark.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Point at crop leaves for best results',
                style: TextStyle(color: AppColors.pureWhite),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(File imageFile, CropDetectionProvider provider) {
    print('Building image preview for file: ${imageFile.path}');
    return Stack(
      children: [
        Positioned.fill(child: Image.file(imageFile, fit: BoxFit.cover)),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                print('Analyze button pressed');
                await provider.analyzeImage();
                if (provider.disease != null) {
                  _showResultsBottomSheet(provider.disease!);
                } else {
                  print('No disease detected after analysis');
                }
              },
              icon: const Icon(Icons.search, size: 28),
              label: const Text(
                'ANALYZE IMAGE',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.pureWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
                shadowColor: AppColors.primary.withOpacity(0.5),
              ),
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 20,
          child: FloatingActionButton(
            heroTag: 'retake',
            mini: true,
            onPressed: () {
              print('Retake button pressed');
              provider.reset();
              setState(() => _showCamera = true);
            },
            backgroundColor: AppColors.pureWhite,
            child: const Icon(Icons.close, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildResultView(CropDisease disease) {
    print('Building result view for disease: ${disease.name}');
    final provider = context.read<CropDetectionProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            disease.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            disease.description,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 20),

          const Text(
            'Recommended Treatment',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            disease.treatmentSuggestion,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 20),

          const Text(
            'Prevention Tips',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            disease.preventionSuggestion,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    print('Close button pressed');
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightGrey,
                    foregroundColor: AppColors.dark,
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
                    print('Scan Again button pressed');
                    Navigator.pop(context);
                    provider.reset();
                    setState(() => _showCamera = true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.pureWhite,
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
      ),
    );
  }

  Widget _buildCameraButtons() {
    print('Building camera buttons');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          heroTag: 'gallery',
          onPressed: _pickImageFromGallery,
          backgroundColor: AppColors.pureWhite,
          child: const Icon(Icons.photo_library, color: AppColors.primary),
        ),
        const SizedBox(width: 30),
        FloatingActionButton(
          heroTag: 'camera',
          onPressed: _takePicture,
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.camera_alt, color: AppColors.pureWhite),
        ),
      ],
    );
  }
}
