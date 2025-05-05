import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studytogether_app/pages/chat.dart';

// This screen (page) of the app shows all the accepted study partners of the
// current user.
// it displays each study partner only once and opens the 1 to 1 chat page
// when the signed in user taps on the study partner's name.
class AcceptedPartnersPage extends StatelessWidget {
  const AcceptedPartnersPage({super.key});

  // Fetches all accepted study partners for the current user.
  // Only returns one entry per user even if multiple requests exist.
  Future<List<Map<String, dynamic>>> fetchAcceptedPartners() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final currentUserUID = currentUser.uid;

    // Query all accepted requests where current user is sender or receiver
    // and where the status is 'accepted'.
    // Note: This assumes that the 'fromUID' and 'toUID' fields are always
    // present in the documents.
    final snapshot = await FirebaseFirestore.instance
        .collection('StudyRequests')
        .where('status', isEqualTo: 'accepted')
        .where(Filter.or(
          Filter('fromUID', isEqualTo: currentUserUID),
          Filter('toUID', isEqualTo: currentUserUID),
        ))
        .get();

    final seenUIDs = <String>{};
    final partners = <Map<String, dynamic>>[];

    for (final doc in snapshot.docs) {
      final fromUID = doc['fromUID'];
      final toUID = doc['toUID'];
      final fromName = doc['fromName'];
      final toName = doc['toName'];

      // Skip if the required fields are missing.
      if (fromUID == null ||
          toUID == null ||
          fromName == null ||
          toName == null) {
        continue;
      }

      // Identify the Other user (not the current user).
      String partnerUID;
      String partnerName;

      if (fromUID == currentUserUID) {
        partnerUID = toUID;
        partnerName = toName;
      } else {
        partnerUID = fromUID;
        partnerName = fromName;
      }

      // Add to the result if not already added.
      if (partnerUID.trim().isNotEmpty && !seenUIDs.contains(partnerUID)) {
        seenUIDs.add(partnerUID);
        partners.add({
          'uid': partnerUID,
          'name': partnerName,
        });
      }
    }

    return partners;
  }

// This method builds the UI for the page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Chat"),
            Text(
              "Accepted Study Partners (please tap to chat)",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAcceptedPartners(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final partners = snapshot.data ?? [];

          if (partners.isEmpty) {
            return const Center(child: Text("No accepted study partners yet."));
          }

          return ListView.builder(
            itemCount: partners.length,
            itemBuilder: (context, index) {
              final partner = partners[index];

              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(partner['name']),
                // trailing: const Icon(Icons.chat_bubble_outline),
                onTap: () {
                  // Go to chat page with the selected partner
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        otherUserId: partner['uid'],
                        otherUserName: partner['name'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
