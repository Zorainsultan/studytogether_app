import 'package:flutter/material.dart';

class CreateSessionPage extends StatelessWidget {
  const CreateSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Session'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'CREATE SESSION - EMPTY SPACE',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
