// lib/screens/Auth/signup_screen.dart
import 'package:agrosmart/provider/auth_provider.dart';
import 'package:agrosmart/screen/Auth/login_screen.dart';
import 'package:agrosmart/screen/dasboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrosmart/Constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordObscureText = true;
  bool _confirmPasswordObscureText = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.03),
                Center(
                  child: Image.asset(
                    "assets/ui_kit/auth.png",
                    height: size.height * 0.25,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  'Jisajili',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tengeneza akaunti ya Agrosmart',
                  style: TextStyle(fontSize: 16, color: AppColors.subtext),
                ),
                SizedBox(height: size.height * 0.04),
                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: AppColors.subtext,
                    ),
                    labelText: "Jina kamili",
                    labelStyle: TextStyle(color: AppColors.subtext),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.subtext.withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.subtext.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tafadhali ingiza jina lako';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppColors.subtext,
                    ),
                    labelText: "Barua pepe",
                    labelStyle: TextStyle(color: AppColors.subtext),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.subtext.withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.subtext.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tafadhali ingiza barua pepe yako';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Tafadhali ingiza barua pepe halali';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _passwordObscureText,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppColors.subtext,
                    ),
                    labelText: "Nenosiri",
                    labelStyle: TextStyle(color: AppColors.subtext),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.subtext.withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.subtext.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordObscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.subtext,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordObscureText = !_passwordObscureText;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tafadhali ingiza nenosiri';
                    }
                    if (value.length < 6) {
                      return 'Nenosiri lazima liwe na herufi 6 au zaidi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _confirmPasswordObscureText,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppColors.subtext,
                    ),
                    labelText: "Thibitisha Nenosiri",
                    labelStyle: TextStyle(color: AppColors.subtext),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.subtext.withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.subtext.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmPasswordObscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.subtext,
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmPasswordObscureText =
                              !_confirmPasswordObscureText;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tafadhali thibitisha nenosiri';
                    }
                    if (value != _passwordController.text) {
                      return 'Nenosiri hazifanani';
                    }
                    return null;
                  },
                ),
                if (authProvider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      authProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 24),
                // Signup Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed:
                        authProvider.isLoading
                            ? null
                            : () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await authProvider.signup(
                                    _nameController.text.trim(),
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  );
                                  // Navigate to dashboard on success
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Dashboard(),
                                    ),
                                  );
                                } catch (e) {
                                  // Error is already handled in provider
                                }
                              }
                            },
                    child:
                        authProvider.isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              "Jisajili",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                // Social Signup Section
                _buildSocialSignup(context),
                SizedBox(height: size.height * 0.03),
                // Login Prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Una akaunti? ",
                      style: TextStyle(color: AppColors.subtext),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Ingia",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialSignup(BuildContext context) {
    return Column(
      children: [
        // Divider with "OR" text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppColors.subtext.withOpacity(0.3),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "au",
                style: TextStyle(color: AppColors.subtext, fontSize: 14),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppColors.subtext.withOpacity(0.3),
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Social buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google
            SocialAuthButton(
              iconPath: 'assets/icons/google.svg',
              onPressed: () {
                // Handle Google sign up
              },
            ),
            const SizedBox(width: 20),
            // Facebook
            SocialAuthButton(
              iconPath: 'assets/icons/facebook.svg',
              onPressed: () {
                // Handle Facebook sign up
              },
            ),
            const SizedBox(width: 20),
            // Apple
            SocialAuthButton(
              iconPath: 'assets/icons/apple.svg',
              onPressed: () {
                // Handle Apple sign up
              },
            ),
          ],
        ),
      ],
    );
  }
}

class SocialAuthButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;

  const SocialAuthButton({
    super.key,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.subtext.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: SvgPicture.asset(iconPath, width: 24, height: 24),
      ),
    );
  }
}
