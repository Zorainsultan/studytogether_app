import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studytogether_app/auth/login_or_register.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // logout function
  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    // take user back to login/register page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginOrRegister()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("StudyTogether"),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          "Welcome to StudyTogether!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
