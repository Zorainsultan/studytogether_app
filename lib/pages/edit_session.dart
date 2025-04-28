import 'package:flutter/material.dart';
import 'package:studytogether_app/studysessions/studysessions.dart';

class EditSessionDialog {
  // Show dialog to edit session info
  static void show({
    required BuildContext context,
    required StudySession session,
    required Function(
            String course, String topic, String location, DateTime date)
        onSave,
  }) {
    final formKey = GlobalKey<FormState>();

    final TextEditingController courseController =
        TextEditingController(text: session.course);
    final TextEditingController topicController =
        TextEditingController(text: session.topic);
    final TextEditingController locationController =
        TextEditingController(text: session.location);

    DateTime selectedDate = DateTime.parse(session.date);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Study Session'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Course
                    TextFormField(
                      controller: courseController,
                      decoration: const InputDecoration(labelText: 'Course'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter course' : null,
                    ),

                    // Topic
                    TextFormField(
                      controller: topicController,
                      decoration: const InputDecoration(labelText: 'Topic'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter topic' : null,
                    ),

                    // Location
                    TextFormField(
                      controller: locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter location' : null,
                    ),

                    const SizedBox(height: 12),

                    // Date Picker
                    ListTile(
                      title: Text(
                        'Date: ${selectedDate.toLocal().toString().split(' ')[0]}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    onSave(
                      courseController.text.trim(),
                      topicController.text.trim(),
                      locationController.text.trim(),
                      selectedDate,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
      },
    );
  }
}
