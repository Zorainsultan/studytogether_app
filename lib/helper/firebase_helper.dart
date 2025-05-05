import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Helper to fetch the logged-in user's name from Firestore
Future<String> fetchNameFromFirebase() async {
  final currentUser = FirebaseAuth.instance.currentUser;

  // Only go ahead/proceed if the user is logged in
  if (currentUser != null) {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .get();

      // Return the name if it's there, else return empty string
      return doc.data()?['fullName'] ?? '';
    } catch (e) {
      // Handle any errors (permisson issues etc)
      return '';
    }
  }

  // Return an empty string if the user is not logged in
  return '';
}
