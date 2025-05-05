import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studytogether_app/studysessions/studysessions.dart';
import 'package:studytogether_app/helper/date_helper.dart';
import 'package:studytogether_app/pages/edit_session.dart';

// This page allows users to join a study session.
class JoinSessionPage extends StatelessWidget {
  const JoinSessionPage({super.key});

//Build method for the JoinSessionPage widget
  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email ??
        'unknown'; //grab the current logged in user's email if no user set to unknown

//main structure of the page.
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8), // background
      appBar: AppBar(
        title: const Text('Join a Study Session'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
//arrange by date the study sessions , auto refresh when updated
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('StudySessions')
            .orderBy('date')
            .snapshots(),
//while loading, show a circular progress indicator
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
//if no session available, show this message.=
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No sessions available yet.'));
          }

//if there are sessions, filter them by date and show them
          final docs = snapshot.data!.docs;
          final now = DateTime.now(); //Get the current time

          final sessions = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return StudySession.fromMap(doc.id, data);
          }).where((session) {
            final sessionDate = DateTime.parse(session.date);
            return sessionDate.isAfter(now); // Only keep sessions in the future
          }).toList();

          if (sessions.isEmpty) {
            return const Center(child: Text('No upcoming sessions.'));
          }

//scroallable list of sessions
          return ListView.builder(
            padding: const EdgeInsets.all(16), //padding for nice look
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              final hasJoined = session.participants.contains(userEmail);
//date formatted
              final sessionDate = DateTime.parse(session.date);
              final properDate =
                  '${sessionDate.day} ${monthName(sessionDate.month)} ${sessionDate.year}';

//display each session in a card
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
//card spec
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
// Show Edit icon if the user is the host
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${session.course} - ${session.topic}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (session.hostDetails == userEmail) ...[
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              color: Colors.blueGrey,
                              onPressed: () {
                                EditSessionDialog.show(
                                  context: context,
                                  session: session,
                                  onSave: (newCourse, newTopic, newLocation,
                                      newDate) async {
                                    await FirebaseFirestore.instance
                                        .collection('StudySessions')
                                        .doc(session.id)
                                        .update({
                                      'course': newCourse,
                                      'topic': newTopic,
                                      'fullLocation': newLocation,
                                      'date': newDate.toIso8601String(),
                                    });
                                  },
                                );
                              },
                            ),

//Delete button and functionality
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              color: Colors.redAccent,
                              onPressed: () async {
                                final confirmDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Session'),
                                    content: const Text(
                                        'Are you sure you want to delete this session? This action cannot be undone.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Delete',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmDelete == true) {
                                  await FirebaseFirestore.instance
                                      .collection('StudySessions')
                                      .doc(session.id)
                                      .delete();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Session deleted successfully.')),
                                  );
                                }
                              },
                            ),
                          ],
                        ],
                      ),

//Session details visible to all users
                      Text(
                        'Location: ${session.location.isNotEmpty ? session.location : 'Unavailable'}\n'
                        'Date: $properDate | Time: ${session.startTime.isNotEmpty ? session.startTime : 'Unavailable'} - ${session.endTime.isNotEmpty ? session.endTime : 'Unavailable'}\n'
                        'Recurring: ${session.recurring ? 'Yes' : 'No'}\n'
                        'Participants: ${session.participants.length}\n'
                        'Host Details: ${session.hostDetails.isNotEmpty ? session.hostDetails : 'Unavailable'}\n',
                      ),

                      const SizedBox(height: 16),

//button for join/unjoin session
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasJoined
                                ? const Color.fromARGB(224, 244, 67, 54)
                                : const Color.fromARGB(224, 76, 175, 79),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(hasJoined
                                    ? 'Leave Session'
                                    : 'Join Session'),
                                content: Text(
                                  hasJoined
                                      ? 'Are you sure you want to leave this session?'
                                      : 'Are you sure you want to join this session?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text(hasJoined ? 'Leave' : 'Join'),
                                  ),
                                ],
                              ),
                            );

//if user confirms, update the session participants list on firebase
                            if (confirm == true) {
                              final updatedParticipants =
                                  List<String>.from(session.participants);

                              if (hasJoined) {
                                updatedParticipants.remove(userEmail);
                              } else {
                                updatedParticipants.add(userEmail);
                              }

                              await FirebaseFirestore.instance
                                  .collection('StudySessions')
                                  .doc(session.id)
                                  .update(
                                      {'participants': updatedParticipants});

//short msg to show user after joining or leaving session
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    hasJoined
                                        ? 'You have left a session.'
                                        : 'You have joined a session!',
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                              hasJoined ? 'Leave Session' : 'Join Session'),
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
