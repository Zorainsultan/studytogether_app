import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studytogether_app/pages/user_profileDialog.dart';

class SearchResultsPage extends StatelessWidget {
  final String university;
  final String course;

  const SearchResultsPage({
    super.key,
    required this.university,
    required this.course,
  });

  // stream that returns users matching the selected university and course
  Stream<QuerySnapshot> _getFilteredUsers() {
    return FirebaseFirestore.instance
        .collection('Users')
        .where('university', isEqualTo: university)
        .where('major', isEqualTo: course)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Search Results'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getFilteredUsers(),
        builder: (context, snapshot) {
          // show loading spinner while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data?.docs ?? [];

          // exclude the current signed-in user from results
          final filteredUsers = users.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['email'] != currentUserEmail;
          }).toList();

          // if no users found, display message
          if (filteredUsers.isEmpty) {
            return const Center(
              child: Text(
                'No users found. Try different filters.',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // info box shown at the top of results
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color.fromARGB(255, 186, 227, 239),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[900]),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Please tap on a user to view their profile or send a study request. Once accepted, you\'ll be able to chat.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[900],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // display each matching user in a card
              ...filteredUsers.map((doc) {
                final userData = doc.data() as Map<String, dynamic>;
                final name = userData['fullName'] ?? 'Unknown';
                final university =
                    userData['university'] ?? 'Unknown University';
                final course = userData['major'] ?? 'Unknown Course';

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading:
                        const Icon(Icons.person, size: 30, color: Colors.blue),
                    title: Text(name),
                    subtitle: Text('$university\n$course'),
                    isThreeLine: true,
                    onTap: () {
                      final email = userData['email'] ?? 'N/A';
                      final level = userData['level'] ?? 'N/A';
                      final bio = userData['bio'];

                      // show profile dialog when user taps a card
                      ShowUserProfileDialog.show(
                        context: context,
                        fullName: name,
                        email: email,
                        university: university,
                        course: course,
                        studyLevel: level,
                        bio: bio,
                      );
                    },
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
