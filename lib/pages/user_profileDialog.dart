import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// This class shows a dialog with the profile details of a user.
// It also lets the current user send a study request.
class ShowUserProfileDialog {
  static void show({
    required BuildContext context,
    required String fullName,
    required String email,
    required String university,
    required String course,
    required String studyLevel,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('User Profile'),

          // profile info section
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
              ],
            ),
          ),

          // action buttons below the dialog
          actions: [
            // button to send a study request
            IconButton(
              icon: const Icon(Icons.person_add_alt_1),
              tooltip: 'Request to Study',
              onPressed: () async {
                final fromUser = FirebaseAuth.instance.currentUser;
                final fromEmail = fromUser?.email;
                if (fromUser == null || fromEmail == null) return;

                // check if a request already exists between these users
                final existingRequest = await FirebaseFirestore.instance
                    .collection('StudyRequests')
                    .where(Filter.or(
                      Filter.and(
                        Filter('fromEmail', isEqualTo: fromEmail),
                        Filter('toEmail', isEqualTo: email),
                      ),
                      Filter.and(
                        Filter('fromEmail', isEqualTo: email),
                        Filter('toEmail', isEqualTo: fromEmail),
                      ),
                    ))
                    .where('status', whereIn: ['pending', 'accepted'])
                    .limit(1)
                    .get();

                if (existingRequest.docs.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('You are already connected with $fullName.'),
                    ),
                  );
                  return;
                }

                // get current user's full name
                final userDoc = await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(fromUser.uid)
                    .get();
                final fromName = userDoc.data()?['fullName'] ?? 'unknown';

                // create a new study request document
                final request = {
                  'fromEmail': fromEmail,
                  'fromUID': fromUser.uid,
                  'fromName': fromName,
                  'toEmail': email,
                  'toUID': await _getUIDFromEmail(email),
                  'toName': fullName,
                  'timestamp': FieldValue.serverTimestamp(),
                  'status': 'pending',
                  'read': false,
                };

                // add the request to Firestore
                await FirebaseFirestore.instance
                    .collection('StudyRequests')
                    .add(request);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Study request sent to $fullName')),
                );
              },
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // helper method to get the UID of a user by their email
  static Future<String> _getUIDFromEmail(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      return data['uid'] ?? snapshot.docs.first.id;
    }
    return 'unknown_uid';
  }
}
