import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studytogether_app/studysessions/studysessions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JoinSessionPage extends StatelessWidget {
  const JoinSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join a Study Session')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('StudySessions')
            .orderBy('date')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No sessions available yet.'));
          }

          final docs = snapshot.data!.docs;
          final sessions = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return StudySession.fromMap(doc.id, data);
          }).toList();

          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              final userEmail =
                  FirebaseAuth.instance.currentUser?.email ?? 'unknown';
              final hasJoined = session.participants.contains(userEmail);

              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${session.course} - ${session.topic}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        'Location: ${session.location}\n'
                        'Date: ${session.date} | Time: ${session.time}\n'
                        'Recurring: ${session.recurring ? 'Yes' : 'No'}\n'
                        'Participants: ${session.participants.length}',
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!hasJoined) {
                              final updatedParticipants = [
                                ...session.participants,
                                userEmail
                              ];
                              await FirebaseFirestore.instance
                                  .collection('StudySessions')
                                  .doc(session.id)
                                  .update(
                                      {'participants': updatedParticipants});
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('You joined the session!')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'You already joined this session.')),
                              );
                            }
                          },
                          child: Text(hasJoined ? 'Joined' : 'Join'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
