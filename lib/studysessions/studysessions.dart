class StudySession {
  final String id;
  final String course;
  final String topic;
  final String location;
  final String description;
  final String date;
  final String startTime;
  final String endTime;
  final bool recurring;
  final String hostDetails;
  final List<String> participants;

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
