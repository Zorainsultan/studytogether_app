import 'package:flutter/material.dart';

class JoinSessionPage extends StatelessWidget {
  const JoinSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join a Session'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Join Session - EMPTY SPACE',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
