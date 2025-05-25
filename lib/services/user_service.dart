import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  // Create user record manually (store password in Firestore — WARNING: plain text is insecure)
  Future<String> createUserRecord({
    required String email,
    required String fullName,
    required String phone,
    required String password,
    String? profileImagePath,
  }) async {
    final usersCollection = _firebase.collection('users');

    // Check if email already exists
    final query = await usersCollection.where('email', isEqualTo: email).get();
    if (query.docs.isNotEmpty) {
      throw Exception('Email already registered');
    }

    final docRef = await usersCollection.add({
      'email': email,
      'password': password, // store hashed password in real apps
      'fullName': fullName,
      'phone': phone,
      'profilePictureURL': profileImagePath ?? 'assets/avatar',
      'role': '1',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id; // Return the document ID
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final query = await _firebase.collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.data();
    }
    return null;
  }

  // Login by checking email and password from Firestore
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final query = await _firebase
        .collection('users')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final userDoc = query.docs.first;
      final userData = userDoc.data();
      // Include userId inside returned map for convenience
      userData['userId'] = userDoc.id;
      print(userData);
      return userData;
    }
    return null; // login failed
  }


  // Fetch user by document ID
  Future<Map<String, dynamic>?> getUserById(String uid) async {
    final doc = await _firebase.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }

  // Update user data by doc ID
  Future<void> editUserById(String uid, Map<String, dynamic> data) async {
    await _firebase.collection('users').doc(uid).update(data);
  }

  Future<void> changePassword({
    required String uid,
    required String currentPassword,
    required String newPassword,
  }) async {
    final doc = await _firebase.collection('users').doc(uid).get();

    if (!doc.exists) {
      throw Exception('User not found');
    }

    final userData = doc.data();

    if (userData == null || userData['password'] != currentPassword) {
      throw Exception('Current password is incorrect');
    }

    await _firebase.collection('users').doc(uid).update({
      'password': newPassword, // Remember to hash in real apps
    });
  }
}