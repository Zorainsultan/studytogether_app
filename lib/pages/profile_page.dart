import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studytogether_app/auth/login_or_register.dart';
import 'package:studytogether_app/pages/edit_profile.dart';

// This screen (page) of the app shows the profile of the current user.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// This class handles the state of the ProfilePage.
// It fetches user details from Firestore, allows editing of the profile,
// and handles user logout.
class _ProfilePageState extends State<ProfilePage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  Future<void> getUserDetails() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser?.uid)
        .get();

    if (snapshot.exists) {
      setState(() {
        userData = snapshot.data();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

// This function handles user logout.
// It signs the user out from Firebase and navigates to the login/register page.
  void logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginOrRegister()),
      );
    }
  }

// This function opens the EditProfileDialog.
// It allows the user to edit their profile information.
// The dialog is pre-filled with the current user's information.
// After saving, it updates the Firestore document and refreshes the user data.
  void openEditProfile() {
    EditProfileDialog.show(
      context: context,
      fullNameController: TextEditingController(text: userData?['fullName']),
      emailController: TextEditingController(text: currentUser?.email),
      universityController:
          TextEditingController(text: userData?['university']),
      courseController: TextEditingController(text: userData?['major']),
      currentStudyLevel: userData?['level'] ?? '',
      onSave: (fullName, email, university, course, level) async {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser?.uid)
            .update({
          'fullName': fullName,
          'email': email,
          'university': university,
          'major': course,
          'level': level,
        });
        getUserDetails(); // Refresh after save
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: openEditProfile,
            icon: const Icon(Icons.edit,
                color: Color.fromARGB(255, 255, 255, 255)),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // only take required height
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //profile picture
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blueGrey,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      userData!['fullName'] ?? 'Name',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentUser?.email ?? 'your@email.com',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(userData!['university'] ?? 'University'),
                    Text(userData!['major'] ?? 'Course'),
                    Text("Study Level: ${userData!['level'] ?? 'N/A'}"),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: logout,
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        "Log Out",
                        style: TextStyle(color: Colors.white), // white text
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
