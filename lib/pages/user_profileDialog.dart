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

                  //check if a request already exists between the two users if it does you see the snackbar message
                  final existingRequest = await FirebaseFirestore.instance
                      .collection('StudyRequests')
                      .where(Filter.or(
                        Filter.and(
                          Filter('fromEmail', isEqualTo: currentUserEmail),
                          Filter('toEmail', isEqualTo: email),
                        ),
                        Filter.and(
                          Filter('fromEmail', isEqualTo: email),
                          Filter('toEmail', isEqualTo: currentUserEmail),
                        ),
                      ))
                      .where('status', whereIn: ['pending', 'accepted'])
                      .limit(1)
                      .get();

                  if (existingRequest.docs.isNotEmpty) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'You are already connected with $fullName!')),
                    );
                    return;
                  }

                  //get sender full name
                  final snapshot = await FirebaseFirestore.instance
                      .collection('Users')
                      .where('email', isEqualTo: currentUserEmail)
                      .limit(1)
                      .get();

                  final fromName = snapshot.docs.isNotEmpty
                      ? snapshot.docs.first['fullName']
                      : 'unknown';

                  //create request data
                  final request = {
                    'fromEmail': currentUserEmail,
                    'fromUID': fromUser.uid,
                    'fromName': fromName,
                    'toEmail': email,
                    'toUID': await _getUIDFromEmail(email),
                    'toName': fullName,
                    'timestamp': FieldValue.serverTimestamp(),
                    'status': 'pending',
                    'read': false
                  };

                  //save request to firestore
                  await FirebaseFirestore.instance
                      .collection('StudyRequests')
                      .add(request);

                  //close dialog and show snackbar
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Study request sent to $fullName!')),
                  );
                },
              ),
            ],
          ),

          //profile info section
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

  //get user uid by email
  static Future<String> _getUIDFromEmail(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      if (data.containsKey('uid')) {
        return data['uid'];
      } else {
        return snapshot.docs.first.id;
      }
    } else {
      return 'unknown_uid';
    }
  }
}
