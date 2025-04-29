import 'package:agrosmart/Constants/app_colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/ui_kit/auth.png", height: 200),
            const SizedBox(height: 20),
            Text(
              'Ingia',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
            Text(
              'Ingia kwenye akaunti yako ya Agrosmart',
              style: TextStyle(fontSize: 15, color: AppColors.subtext),
              textAlign: TextAlign.left,
            ),
            // Form
            _buildForm(context),
          ],
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
            labelText: "Email/Username",
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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.all(15),
            ),

            onPressed: () {
              debugPrint("Sign Up");
            },
            child: Text("Sign Up"),
          ),
        ),
      ],
    ),
  );
}
