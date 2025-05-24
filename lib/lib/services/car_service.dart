import 'package:cloud_firestore/cloud_firestore.dart';

class CarService {
  final CollectionReference carsCollection = FirebaseFirestore.instance.collection('cars');

  Future<Map<String, dynamic>?> getCarById(String id) async {
    try {
      DocumentSnapshot doc = await carsCollection.doc(id).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching car: $e');
      return null;
    }
  }
}
