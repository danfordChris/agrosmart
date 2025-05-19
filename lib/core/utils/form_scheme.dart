import 'package:flutter/material.dart';

class FormScheme {

    final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;






  //   @override
  // void setup(UserModel? data) {
  //   if (data == null) return;
  //   _nameController.text = data.name ?? "";
  //   _emailController.text = data.email ?? "";
  //   _genderController.init(data.gender);
  // }

  // @override
  // void setupSample(UserModel? data) {
  //   super.setupSample(data);
  //   _nameController.text = "iPF Softwares";
  //   _emailController.text = "ipfsoftwares@ipfsoftwares.com";
  //   _genderController.init("M");
  // }

  // UserModel get toUser {
  //   return UserModel(
  //     name: _nameController.text.trim(),
  //     email: _emailController.text.trim(),
  //     gender: _genderController.value,
  //   );User
  // }

}