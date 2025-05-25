import '../theme/theme.dart';
import '../theme/custom_nav_bar.dart';
import '../theme/custom_app_bar.dart';
import '../services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();

  String? userId;
  String name = "";
  String email = "";
  String phone = "";
  String? profileImage;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getString('userId');

    if (storedUserId == null) {
      // No userId found, not logged in
      setState(() => _isLoading = false);
      return;
    }

    userId = storedUserId;
    final userData = await _userService.getUserById(userId!);

    if (userData != null) {
      setState(() {
        name = userData['fullName'] ?? "";
        email = userData['email'] ?? "";
        phone = userData['phone'] ?? "";
        profileImage = userData['profileImagePath'];
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _editProfile(BuildContext context) {
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);
    final phoneController = TextEditingController(text: phone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full Name')),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User ID not found. Please login again.')),
                );
                Navigator.pop(context);
                return;
              }

              try {
                await _userService.editUserById(userId!, {
                  'fullName': nameController.text.trim(),
                  'email': emailController.text.trim(),
                  'phone': phoneController.text.trim(),
                });

                setState(() {
                  name = nameController.text.trim();
                  email = emailController.text.trim();
                  phone = phoneController.text.trim();
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update profile: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: currentPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Current Password')),
              TextField(controller: newPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'New Password')),
              TextField(controller: confirmPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm New Password')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final currentPassword = currentPasswordController.text.trim();
              final newPassword = newPasswordController.text.trim();
              final confirmPassword = confirmPasswordController.text.trim();

              if (newPassword != confirmPassword) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("New passwords don't match")),
                );
                return;
              }

              if (userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User ID not found. Please login again.')),
                );
                return;
              }

              try {
                await _userService.changePassword(uid: userId!, currentPassword: currentPassword, newPassword: newPassword);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password changed successfully")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to change password: $e")),
                );
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logged out successfully")),
      );
      Navigator.of(context).pushReplacementNamed('/auth');  // Make sure you have this route
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Profile', showAvatar: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                backgroundImage: profileImage != null && profileImage!.isNotEmpty
                    ? AssetImage(profileImage!) // Or NetworkImage if URL
                    : null,
                child: profileImage == null || profileImage!.isEmpty
                    ? const Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Full Name', name),
                    const SizedBox(height: 20),
                    _buildInfoRow('Email', email),
                    const SizedBox(height: 20),
                    _buildInfoRow('Phone', phone),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildActionButton(Icons.edit, "Edit Profile", () => _editProfile(context)),
            const SizedBox(height: 15),
            _buildActionButton(Icons.lock_outline, "Change Password", _changePassword),
            const SizedBox(height: 15),
            _buildActionButton(Icons.logout, "Logout", _logout, color: AppColors.favoriteRed),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 4,
        onTap: (index) {
          // Navigation logic if needed
        },
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: AppColors.description, fontSize: 14)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap, {Color color = AppColors.mainButtonBackground}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white)),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}