import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studytogether_app/auth/login_or_register.dart';
import 'package:studytogether_app/helper/firebase_helper.dart';
import 'package:studytogether_app/pages/notifications_panel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studytogether_app/pages/accepted_partners.dart';

// This pahge is the home page of the app.
// First page the user sees after login.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Logout function which logs the user out and send them to the login page.
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
          // Notifications icon with red dot
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('StudyRequests')
                .where('toEmail',
                    isEqualTo: FirebaseAuth.instance.currentUser?.email)
                .where('read', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              final hasUnread =
                  snapshot.hasData && snapshot.data!.docs.isNotEmpty;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications), // Notification icon
                    tooltip: 'Study Requests',
                    onPressed: () async {
                      // When the icon is pressed, mark all unread requests as read
                      final currentUserEmail =
                          FirebaseAuth.instance.currentUser?.email;

                      final unreadRequests = await FirebaseFirestore.instance
                          .collection('StudyRequests')
                          .where('toEmail', isEqualTo: currentUserEmail)
                          .where('read', isEqualTo: false)
                          .get();

                      for (var doc in unreadRequests.docs) {
                        await doc.reference.update({'read': true});
                      }

                      // Then show panel
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => const NotificationsPanel(),
                      );
                    },
                  ),
                  if (hasUnread)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          //logout button
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

          // Greeting message
          // This will be replaced with the user's name from Firebase
          // If the name is not available, it will show "Hello 👋"
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
                    "Hello 👋",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  );
                } else {
                  return Text(
                    "Hello ${snapshot.data!} 👋",
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AcceptedPartnersPage(),
              ),
            );
          }),
          featureTile('Your Profile', Icons.person_outline, () {
            Navigator.pushNamed(context, '/profile');
          }),
        ],
      ),
    );
  }
}
