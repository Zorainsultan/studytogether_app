import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studytogether_app/auth/login_or_register.dart';
import 'package:studytogether_app/helper/firebase_helper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // logout function
  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginOrRegister()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Feature tile used for all 4 options
    Widget featureTile(String label, IconData icon, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            child: Row(
              children: [
                Icon(icon, size: 28, color: Colors.blue[900]),
                const SizedBox(width: 15),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("StudyTogether"),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),

          // greeting msg
          Center(
            child: FutureBuilder<String>(
              future: fetchNameFromFirebase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // while loading
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return Text(
                    "Welcome 👋",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  );
                } else {
                  return Text(
                    "Welcome ${snapshot.data!} 👋",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 30),

          // 4 interactive features
          featureTile('Join / Create Session', Icons.calendar_today_outlined,
              () {
            Navigator.pushNamed(context, '/session');
          }),
          featureTile('Find Study Partners', Icons.find_in_page_outlined, () {
            Navigator.pushNamed(context, '/find');
          }),
          featureTile('Chat', Icons.chat_bubble_outline, () {
            Navigator.pushNamed(context, '/chat');
          }),
          featureTile('Profile', Icons.person_outline, () {
            Navigator.pushNamed(context, '/profile');
          }),
        ],
      ),
    );
  }
}
