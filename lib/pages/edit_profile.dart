import 'package:flutter/material.dart';

// A utility class to show a dialog for editing user profile information.
class EditProfileDialog {
  static void show({
    required BuildContext context,
    required TextEditingController fullNameController,
    required TextEditingController emailController,
    required TextEditingController universityController,
    required TextEditingController courseController,
    required String currentStudyLevel,
    required Function(String, String, String, String, String) onSave,
  }) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController studyLevelController =
        TextEditingController(text: currentStudyLevel);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Profile'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name
                    TextFormField(
                      controller: fullNameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter your name' : null,
                    ),

                    // Email
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter your email' : null,
                    ),

                    // University
                    TextFormField(
                      controller: universityController,
                      decoration:
                          const InputDecoration(labelText: 'University'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter university' : null,
                    ),

                    // course
                    TextFormField(
                      controller: courseController,
                      decoration: const InputDecoration(labelText: 'Course'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter course' : null,
                    ),

                    // Study Level
                    TextFormField(
                      controller: studyLevelController,
                      decoration:
                          const InputDecoration(labelText: 'Study Level'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter study level' : null,
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
                      fullNameController.text,
                      emailController.text,
                      universityController.text,
                      courseController.text,
                      studyLevelController.text,
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
