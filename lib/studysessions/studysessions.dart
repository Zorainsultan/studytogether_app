class StudySession {
  final String id;
  final String course;
  final String topic;
  final String location;
  final String description;
  final String date;
  final String time;
  final bool recurring;
  final List<String> participants;

  StudySession({
    required this.id,
    required this.course,
    required this.topic,
    required this.location,
    required this.description,
    required this.date,
    required this.time,
    required this.recurring,
    required this.participants,
  });

  factory StudySession.fromMap(String id, Map<String, dynamic> data) {
    return StudySession(
      id: id,
      course: data['course'] ?? '',
      topic: data['topic'] ?? '',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      recurring: data['recurring'] ?? false,
      participants: List<String>.from(data['participants'] ?? []),
    );
  }
}
