import 'userAccess/auth_page.dart';
import 'userScreens/home_page.dart';
import 'userScreens/sellCarPage.dart';
import 'userScreens/profile_page.dart';
import '../services/user_service.dart';
import 'package:flutter/material.dart';
import 'userScreens/favourites_page.dart';
import 'userScreens/brand_list_page.dart';
import 'adminScreens/admin_dashboard.dart';
import 'userScreens/choose_action_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'userScreens/sell_requests_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:course_project/userScreens/about_contact_page.dart';
import 'models/sell_request.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Initialize Hive and register the adapter
  await Hive.initFlutter();
  Hive.registerAdapter(SellRequestAdapter());

  await Hive.openBox<SellRequest>('sellRequests');

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Motorly',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF191A1F),
        cardColor: const Color(0xFF1E1E1E),
        primaryColor: const Color(0xFF3D5AFE),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3D5AFE),
          secondary: Color(0xFF3D5AFE),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Color(0xFFAAAAAA)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3D5AFE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Color(0xFF3D5AFE),
            side: const BorderSide(color: Color(0xFF3D5AFE)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshotPrefs) {
          if (!snapshotPrefs.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final prefs = snapshotPrefs.data!;
          final userId = prefs.getString('userId');

          if (userId == null) {
            // No userID in prefs, redirect to SignupPage
            return AuthPage();
          }
          final UserService userService = UserService();
          // userID exists, now fetch user data to check role
          return FutureBuilder<Map<String, dynamic>?>(

            future: userService.getUserById(userId),
            builder: (context, snapshotUser) {
              if (snapshotUser.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (!snapshotUser.hasData || snapshotUser.data == null) {
                // User data not found, force to signup or auth page
                return AuthPage();
              }

              final userData = snapshotUser.data!;
              final role = userData['role'] ?? 'user';  // default to 'user' if role missing

              if (role == 'admin') {
                return AdminDashboardPage();
              } else {
                return CarHomePage();
              }
            },
          );
        },
      ),
      routes: {
        '/homeUser': (context) => CarHomePage(),
        '/homeAdmin': (context) => AdminDashboardPage(),
        '/cars': (context) => BrandListPage(),
        '/profile': (context) => ProfilePage(),
        '/choose': (context) => const ChooseActionPage(),
        '/sellCar': (context) => const SellCarPage(),
        '/sellRequests': (context) => const SellRequestsPage(),
        '/about': (context) => const AboutContactPage(),
        '/favourites': (context) => FavouritesPage(),
        '/auth': (context) => AuthPage(),
      },
    );
  }
}