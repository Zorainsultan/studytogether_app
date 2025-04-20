import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studytogether_app/auth/login_or_register.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Get current user
  User? get currentUser => FirebaseAuth.instance.currentUser;

  // Fetch user data from Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser?.uid)
        .get();
  }

  // Logout function
  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginOrRegister()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching user details'));
          }

          // No data
          if (!snapshot.hasData ||
              snapshot.data == null ||
              !snapshot.data!.exists) {
            return const Center(child: Text('No user data found.'));
          }

          // Extract data
          final userData = snapshot.data!.data()!;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  userData['fullName'] ?? 'Name',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(currentUser?.email ?? 'your@email.com',
                    style: const TextStyle(color: Colors.grey)),
                Text(userData['university'] ?? 'University'),
                Text(userData['major'] ?? 'Course'),
                Text("Study Level: ${userData['level'] ?? 'N/A'}",
                    style: const TextStyle(
                        color: Color.fromARGB(255, 12, 12, 12))),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () => logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text("Log Out"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
