import 'package:flutter/material.dart';

class StudySessionPage extends StatelessWidget {
  const StudySessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Session'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Heading
            const Text(
              'Join or Create a Study Session',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            // Join button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/join');
              },
              icon: const Icon(Icons.login),
              label: const Text('Join a Session'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            const SizedBox(height: 20),

            // Create button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/create');
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Create a Session'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
