// This file defines the StudySession class.
// Each study session has details like course, topic, location, date, time, etc.

class StudySession {
  final String id; // unique ID for the session
  final String course; // course name
  final String topic; // session topic
  final String location; // full location
  final String description; // optional description
  final String date; // session date in ISO 8601 format
  final String startTime; // start time
  final String endTime; // end time
  final bool recurring; // true if the session repeats
  final String hostDetails; // email of the user who created it
  final List<String> participants; // list of user emails who joined

  StudySession({
    required this.id,
    required this.course,
    required this.topic,
    required this.location,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.recurring,
    required this.participants,
    required this.hostDetails,
  });

  // Convert Firestore data into a StudySession object
  factory StudySession.fromMap(String id, Map<String, dynamic> data) {
    return StudySession(
      id: id,
      course: data['course'] ?? '',
      topic: data['topic'] ?? '',
      location: data['fullLocation'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      recurring: data['recurring'] ?? false,
      hostDetails: data['hostDetails'] ?? '',
      participants: List<String>.from(data['participants'] ?? []),
    );
  }
}
