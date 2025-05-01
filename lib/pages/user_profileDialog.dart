import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShowUserProfileDialog {
  static void show({
    required BuildContext context,
    required String fullName,
    required String email,
    required String university,
    required String course,
    required String studyLevel,
    String? bio,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('User Profile'),
              //request to study button
              IconButton(
                icon: const Icon(Icons.person_add_alt_1),
                tooltip: 'Request to Study',

                //store the request in the database when clicked the study request icon
                onPressed: () async {
                  final fromUser = FirebaseAuth.instance.currentUser;
                  if (fromUser == null) return;

                  final request = {
                    'fromEmail': fromUser.email,
                    'fromName': fromUser.displayName ?? 'Anonymous',
                    'toEmail': email,
                    'toName': fullName,
                    'timestamp': FieldValue.serverTimestamp(),
                    'status': 'pending',
                  };

                  await FirebaseFirestore.instance
                      .collection('StudyRequests')
                      .add(request);

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Study request sent to $fullName!')),
                  );
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: $fullName'),
                const SizedBox(height: 8),
                Text('Email: $email'),
                const SizedBox(height: 8),
                Text('University: $university'),
                const SizedBox(height: 8),
                Text('Course: $course'),
                const SizedBox(height: 8),
                Text('Study Level: $studyLevel'),
                if (bio != null && bio.trim().isNotEmpty) ...[
                  const Divider(height: 20),
                  Text(
                    bio,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
          ),

//close button
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
