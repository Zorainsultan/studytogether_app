import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateSessionPage extends StatefulWidget {
  const CreateSessionPage({super.key});

  @override
  State<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for user input
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isRecurring = false;

  // Helper to select a date
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // Helper to select a time
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  // Save the session to Firebase
  Future<void> _saveSession() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in.')),
        );
        return;
      }

      final sessionData = {
        'course': _courseController.text.trim(),
        'topic': _topicController.text.trim(),
        'fullLocation': _locationController.text.trim(),
        'description': _descriptionController.text.trim(),
        'date': _selectedDate!.toIso8601String(),
        'time': _selectedTime!.format(context),
        'isRecurring': _isRecurring,
        'userId': user.uid,
        'createdAt': Timestamp.now(),
        'participants': []
      };

      await FirebaseFirestore.instance
          .collection('StudySessions')
          .add(sessionData);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Session'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Course input
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter course' : null,
              ),

              const SizedBox(height: 12),

              // Topic input
              TextFormField(
                controller: _topicController,
                decoration: const InputDecoration(labelText: 'Topic'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter topic' : null,
              ),

              // Location input
              const SizedBox(height: 12),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Full Location',
                  suffixIcon: Icon(Icons.location_on),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a location' : null,
              ),

              // Description input
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration:
                    const InputDecoration(labelText: 'Session Description'),
              ),

              const SizedBox(height: 20),

              // Date picker
              ListTile(
                title: Text(_selectedDate == null
                    ? 'Pick a Date'
                    : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),

              // Time picker
              ListTile(
                title: Text(_selectedTime == null
                    ? 'Pick a Time'
                    : 'Time: ${_selectedTime!.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: _pickTime,
              ),

              // Recurring toggle
              SwitchListTile(
                value: _isRecurring,
                onChanged: (val) => setState(() => _isRecurring = val),
                title: const Text('Recurring Session?'),
              ),

              const SizedBox(height: 30),

              // Save button
              ElevatedButton.icon(
                onPressed: _saveSession,
                icon: const Icon(Icons.save),
                label: const Text('Create Session'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
