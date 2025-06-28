import 'dart:async';
import 'package:agrosmart/Constants/app_colors.dart';
import 'package:agrosmart/repositories/user_info_repository.dart';
import 'package:agrosmart/screen/dasboard.dart';
import 'package:agrosmart/services/session_manager.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoFadeController;
  late Animation<double> _fadeAnimation;

  String fullText = 'Lima kwa uhakika';
  String displayedText = '';
  int _charIndex = 0;
  Timer? _typewriterTimer;

  @override
  void initState() {
    super.initState();

    // Logo fade controller
    _logoFadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoFadeController, curve: Curves.easeIn),
    );

    _logoFadeController.forward();

    // Delay and then start typewriter
    Future.delayed(const Duration(seconds: 2), () {
      _startTypewriter();
    });

    _loadUserInfo();

    // Navigate after 5 seconds
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const Dashboard()));
    });
  }

  void _loadUserInfo() async {
    final user = await UserInfoRepository.instance.all;
    if (user.isNotEmpty) {
      SessionManager.instance.setUserInfo(user.first);

      print("${SessionManager.instance.user.toJson}");
    }
  }

  void _startTypewriter() {
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      if (_charIndex < fullText.length) {
        setState(() {
          displayedText += fullText[_charIndex];
          _charIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _logoFadeController.dispose();
    _typewriterTimer?.cancel();
    super.dispose();
  }

  Widget _buildLogoText() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Agro',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            'Smart',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypewriterText() {
    return Text(
      displayedText,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLogoText(),
            const SizedBox(height: 8),
            _buildTypewriterText(),
          ],
        ),
      ),
    );
  }
}
