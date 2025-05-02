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

                  final currentUserEmail = fromUser.email ?? '';

                  //fetch the full name of the sender from Users collection
                  final snapshot = await FirebaseFirestore.instance
                      .collection('Users')
                      .where('email', isEqualTo: currentUserEmail)
                      .limit(1)
                      .get();

                  final fromName = snapshot.docs.isNotEmpty
                      ? snapshot.docs.first['fullName']
                      : 'Unknown';

                  //prepare the request data
                  final request = {
                    'fromEmail': currentUserEmail,
                    'fromName': fromName,
                    'toEmail': email,
                    'toName': fullName,
                    'timestamp': FieldValue.serverTimestamp(),
                    'status': 'pending',
                    'read':
                        false, // to check if the notification is read or not
                  };

                  //add the request to firestore
                  await FirebaseFirestore.instance
                      .collection('StudyRequests')
                      .add(request);

                  //close the dialog and show confirmation
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Study request sent to $fullName!')),
                  );
                },
              ),
            ],
          ),

          //profile info content
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
