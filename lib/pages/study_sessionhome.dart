import 'package:flutter/material.dart';

// This widget represents the home page for study sessions.
// It allows users to join or create a study session.
class StudySessionPage extends StatelessWidget {
  const StudySessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Study Sessions'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
        child: Column(
          children: [
            // Join Button
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)), // Rounded corners
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.group, color: Colors.white),
                ),
                title: const Text('Join a Study Session'),
                subtitle: const Text('Browse and join existing sessions'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.pushNamed(context, '/join');
                },
              ),
            ),
            const SizedBox(height: 20),

            // Create Button
            Card(
              elevation: 4, // Add elevation for shadow effect
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.add, color: Colors.white),
                ),
                title: const Text('Create a Study Session'),
                subtitle: const Text('Organise a new session'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.pushNamed(context, '/create');
                },
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
