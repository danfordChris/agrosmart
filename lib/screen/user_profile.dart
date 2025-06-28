import 'package:agrosmart/models/user_info_model.dart';
import 'package:agrosmart/screen/dasboard.dart';
import 'package:agrosmart/screen/edit_profile_screen.dart';
import 'package:agrosmart/services/database_manager.dart';
import 'package:agrosmart/services/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/services.dart'; // For Scenery

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserInfoModel? _userInfo;

  @override
  void initState() {
    super.initState();
    _userInfo = SessionManager.instance.user;
  }

  void _navigateToEditProfile() async {
    if (_userInfo == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(currentUserInfo: _userInfo!),
      ),
    );

    // If the edit screen pops with `true`, it means changes were saved
    if (result == true && mounted) {
      Scenery.showSuccess("Profile updated!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEditProfile,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        _buildProfileHeader(),
        const SizedBox(height: 24),
        _buildProfileDetailItem(
          icon: Icons.person_outline,
          label: 'Username',
          value: _userInfo!.username ?? 'N/A',
        ),
        _buildProfileDetailItem(
          icon: Icons.email_outlined,
          label: 'Email',
          value: _userInfo!.email ?? 'N/A',
        ),
        _buildProfileDetailItem(
          icon: Icons.account_circle_outlined,
          label: 'First Name',
          value: _userInfo!.first_name ?? 'N/A',
        ),
        _buildProfileDetailItem(
          icon: Icons.account_circle_outlined,
          label: 'Last Name',
          value: _userInfo!.last_name ?? 'N/A',
        ),
        _buildProfileDetailItem(
          icon: Icons.phone_outlined,
          label: 'Phone Number',
          value:
              _userInfo!.phone_number?.isNotEmpty == true
                  ? _userInfo!.phone_number!
                  : 'N/A',
        ),
        _buildProfileDetailItem(
          icon: Icons.badge_outlined,
          label: 'ID Number',
          value:
              _userInfo!.id_number?.isNotEmpty == true
                  ? _userInfo!.id_number!
                  : 'N/A',
        ),
        _buildProfileDetailItem(
          icon: Icons.work_outline,
          label: 'Role',
          value: _userInfo!.role ?? 'N/A',
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () async {
            // TODO: Implement logout functionality

            await DatabaseManager.instance.deleteAll;
            SessionManager.instance.clearSession();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text(
            'Logout',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            _userInfo!.first_name?.isNotEmpty == true
                ? _userInfo!.first_name![0].toUpperCase()
                : (_userInfo!.username?.isNotEmpty == true
                    ? _userInfo!.username![0].toUpperCase()
                    : "U"),
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${_userInfo!.first_name ?? ''} ${_userInfo!.last_name ?? ''}'.trim(),
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        if (_userInfo!.email != null)
          Text(
            _userInfo!.email!,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  Widget _buildProfileDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
        ),
      ),
    );
  }
}
