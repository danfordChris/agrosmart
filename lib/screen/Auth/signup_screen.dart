import 'package:agrosmart/Constants/app_colors.dart';
import 'package:agrosmart/screen/Auth/login_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset("assets/ui_kit/auth.png", height: 200),
              const SizedBox(height: 20),

              SizedBox(height: 20),
              Text(
                'Jisajili',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              Text(
                'Tengeneza akaunti ya Agrosmart',
                style: TextStyle(fontSize: 15, color: AppColors.subtext),
                textAlign: TextAlign.left,
              ),

              // Form
              _buildForm(context),
            ],
          ),
        ),
      ),
    );
  }
}

_buildForm(BuildContext context) {
  return Form(
    child: Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: "Name",
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            labelText: "Email",
          ),
        ),
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            labelText: "Password",
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            labelText: "Confirm Password",
          ),
        ),

        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,

          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(AppColors.primary),
            ),

            onPressed: () {
              debugPrint("Sign Up");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text("Sign Up"),
          ),
        ),
      ],
    ),
  );
}
