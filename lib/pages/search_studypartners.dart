import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchPartnersPage extends StatelessWidget {
  const SearchPartnersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Find Study Partners'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          // Show loading spinner while fetching
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If no users found
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          // Get the user documents
          final users = snapshot.data!.docs;

          // List all users except the signed-in user
          final filteredUsers = users.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['email'] != currentUserEmail;
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final userData =
                  filteredUsers[index].data() as Map<String, dynamic>;

              // Safe fallback if fields are missing
              final name = userData['fullName'] ?? 'Unknown';
              final university = userData['university'] ?? 'Unknown University';
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
