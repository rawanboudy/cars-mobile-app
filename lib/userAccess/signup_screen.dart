import 'dart:io';
import 'package:flutter/material.dart';
import '../userScreens/home_page.dart';
import '../services/user_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback onSwitch;

  SignupScreen({required this.onSwitch});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String userId = "";
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final UserService userService = UserService();
  File? _profileImage;

  void signup(BuildContext context) async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }

    try {
      // Check if email already exists in Firestore
      final existingUser = await userService.getUserByEmail(emailController.text.trim());
      if (existingUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email already registered! Please login.")),
        );
        return;
      }

      // Create user document in Firestore
      final newUserId = await userService.createUserRecord(
        email: emailController.text.trim(),
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
        password: password,
        profileImagePath: _profileImage?.path,
      );

      setState(() {
        userId = newUserId;  // update userId here
      });

      // Save userId in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', newUserId);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CarHomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed: $e")),
      );
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade800, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'BoudyCar',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(height: 120),
                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[800],
                      backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                      child: _profileImage == null
                          ? Icon(Icons.camera_alt, size: 30, color: Colors.white70)
                          : null,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        buildInput("Full Name", fullNameController, Icons.person),
                        SizedBox(height: 16),
                        buildInput("Phone Number", phoneController, Icons.phone),
                        SizedBox(height: 16),
                        buildInput("Email address", emailController, Icons.email),
                        SizedBox(height: 16),
                        buildInput("Password", passwordController, Icons.lock, isPassword: true),
                        SizedBox(height: 16),
                        buildInput("Confirm Password", confirmPasswordController, Icons.lock, isPassword: true),
                        SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => signup(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text("Signup", style: TextStyle(fontSize: 16, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: widget.onSwitch,
                    child: Text("Already have an account? Login", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInput(String hint, TextEditingController controller, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white54),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}

// Wavy header
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2, size.height,
      size.width, size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
