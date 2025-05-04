import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsPanel extends StatelessWidget {
  const NotificationsPanel({super.key});

  //update the status of a request (accepted or rejected)
  Future<void> _updateRequestStatus(
      String requestId, String status, BuildContext context) async {
    final requestRef =
        FirebaseFirestore.instance.collection('StudyRequests').doc(requestId);

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    //get full name of current user
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .get();

    final fullName = userDoc.data()?['fullName'] ?? 'unknown';

    //update status and add current user's uid/name if accepted
    await requestRef.update({
      'status': status,
      if (status == 'accepted') ...{
        'toUID': currentUser.uid,
        'toName': fullName,
      }
    });

    //optional: send simple message to sender for notification
    if (status == 'accepted') {
      final requestSnapshot = await requestRef.get();
      final data = requestSnapshot.data();

      if (data != null) {
        await FirebaseFirestore.instance.collection('StudyRequests').add({
          'toEmail': data['fromEmail'],
          'message': '$fullName accepted your study request!',
          'timestamp': FieldValue.serverTimestamp(),
          'read': false,
        });
      }
    }

    //show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request $status.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    //get current user's email
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFFF4F6F8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //panel title
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          //list of incoming requests
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('StudyRequests')
                  .where('toEmail', isEqualTo: currentUserEmail)
                  .where('status', isEqualTo: 'pending')
                  .snapshots(),
              builder: (context, snapshot) {
                //show loading spinner while fetching
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                //if nothing found
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No New Notifications.'));
                }

                final requests = snapshot.data!.docs;

                //show each request in card with accept/reject
                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    final data = request.data() as Map<String, dynamic>;

                    final fromName = data['fromName'] ?? 'unknown';
                    final fromEmail = data['fromEmail'] ?? 'N/A';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(fromName),
                        subtitle: Text('wants to study with you.\n$fromEmail'),
                        isThreeLine: true,
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            //reject button
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              tooltip: 'Reject',
                              onPressed: () => _updateRequestStatus(
                                  request.id, 'rejected', context),
                            ),
                            //accept button
                            IconButton(
                              icon:
                                  const Icon(Icons.check, color: Colors.green),
                              tooltip: 'Accept',
                              onPressed: () => _updateRequestStatus(
                                  request.id, 'accepted', context),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
