import 'package:agrosmart/Constants/app_colors.dart';
import 'package:agrosmart/models/user_info_model.dart';
import 'package:agrosmart/provider/auth_provider.dart';
import 'package:agrosmart/repositories/user_info_repository.dart';
import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/services.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final UserInfoModel currentUserInfo;

  const EditProfileScreen({super.key, required this.currentUserInfo});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _idNumberController;

  final bool _isLoading = false;

  late AuthProvider _authProvider;
  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(
      context,
      listen: false,
    ); // ✅ add `listen: false`

    _firstNameController = TextEditingController(
      text: widget.currentUserInfo.first_name,
    );
    _lastNameController = TextEditingController(
      text: widget.currentUserInfo.last_name,
    );
    _emailController = TextEditingController(
      text: widget.currentUserInfo.email,
    );
    _phoneNumberController = TextEditingController(
      text: widget.currentUserInfo.phone_number,
    );
    _idNumberController = TextEditingController(
      text: widget.currentUserInfo.id_number,
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedInfo = UserInfoModel(
        id: widget.currentUserInfo.id, // Keep the original ID
        username: widget.currentUserInfo.username,
        first_name: _firstNameController.text.trim(),
        last_name: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone_number: _phoneNumberController.text.trim(),
        id_number: _idNumberController.text.trim(),
      );

      await _authProvider.updateProfile(updatedInfo, context);

      Navigator.pop(context);
      Scenery.showSuccess('Profile updated successfully');
    }
  }

  String? _validateIdNumber(String? value) {
    final idNumber = value?.trim() ?? '';
    final phoneNumber = _phoneNumberController.text.trim();

    if (idNumber.isNotEmpty && phoneNumber.isEmpty) {
      return 'Phone number is required if ID number is provided.';
    }
    return null; // No error
  }

  String? _validatePhoneNumber(String? value) {
    // You can add more specific phone number validation if needed
    // For now, this is just to trigger re-validation of ID number
    // if ID number has a value and phone number is cleared.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.validate();
    });
    return null; // No specific validation here, but triggers ID number validation
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveProfile,
          ),
        ],
      ),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.greenMedium,
                  ),
                )
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    margin: const EdgeInsets.only(top: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TextFormField(
                              controller: _firstNameController,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _lastNameController,
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(
                                  r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _phoneNumberController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number (Optional)',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              keyboardType: TextInputType.phone,
                              validator: _validatePhoneNumber,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _idNumberController,
                              decoration: const InputDecoration(
                                labelText: 'ID Number (Optional)',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: _validateIdNumber,
                            ),
                            const SizedBox(height: 32),

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
                                        : _saveProfile,
                                child:
                                    authProvider.isLoading
                                        ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : const Text(
                                          'Save Changes',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
