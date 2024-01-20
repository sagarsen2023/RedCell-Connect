import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> fetchDataFromDocument(
    String collectionName) async {
  Map<String, dynamic> data = {};
  SharedPreferences documentId = await SharedPreferences.getInstance();
  final email = documentId.getString("userEmail").toString();
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(email)
        .get();

    if (documentSnapshot.exists) {
      data = documentSnapshot.data() as Map<String, dynamic>;
      return data;
    } else {
      return data;
    }
  } catch (e) {
    return data;
  }
}
