import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studytogether_app/helper/time_helper.dart';

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
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
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

  // Helper to select start time
  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedStartTime = picked);
  }

// Helper to select end time
  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedEndTime = picked);
  }

  // Save the session to Firebase
  Future<void> _saveSession() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedStartTime != null &&
        _selectedEndTime != null) {
      if (!isEndTimeAfterStartTime(_selectedStartTime!, _selectedEndTime!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End time must be after start time.')),
        );
        return;
      }

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
        'startTime': _selectedStartTime!.format(context),
        'endTime': _selectedEndTime!.format(context),
        'isRecurring': _isRecurring,
        'userId': user.uid,
        'hostDetails': user.email,
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
      backgroundColor: const Color(0xFFF4F6F8), // Match HomePage background
      appBar: AppBar(
        title: const Text('Create Session'),
        backgroundColor: Colors.blue[900], // Match HomePage appbar
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //Information shown before the user starts creating a session
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color.fromARGB(255, 186, 227, 239),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[900]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'All study sessions you create will be visible to other registered students in the join session page.\n\nYou can also edit or delete your sessions anytime from there.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[900],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Course input
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(
                  labelText: 'Course',
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter course' : null,
              ),

              const SizedBox(height: 12),

              // Topic input
              TextFormField(
                controller: _topicController,
                decoration: const InputDecoration(
                  labelText: 'Topic',
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter topic' : null,
              ),

              const SizedBox(height: 12),

              // Location input
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Full Location',
                  suffixIcon: Icon(Icons.location_on),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a location' : null,
              ),

              const SizedBox(height: 12),

              // Description input
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Session Description',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // Date picker
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  tileColor: Colors.white,
                  title: Text(_selectedDate == null
                      ? 'Pick a Date'
                      : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _pickDate,
                ),
              ),

              const SizedBox(height: 12),

              // Start Time picker
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  tileColor: Colors.white,
                  title: Text(_selectedStartTime == null
                      ? 'Pick Start Time'
                      : 'Start Time: ${_selectedStartTime!.format(context)}'),
                  trailing: const Icon(Icons.access_time),
                  onTap: _pickStartTime,
                ),
              ),

              const SizedBox(height: 12),

// End Time picker
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  tileColor: Colors.white,
                  title: Text(_selectedEndTime == null
                      ? 'Pick End Time'
                      : 'End Time: ${_selectedEndTime!.format(context)}'),
                  trailing: const Icon(Icons.more_time),
                  onTap: _pickEndTime,
                ),
              ),

              const SizedBox(height: 12),

              // Recurring toggle
              SwitchListTile(
                value: _isRecurring,
                onChanged: (val) => setState(() => _isRecurring = val),
                title: const Text(
                    'Recurring Session? Plesse use the toggle to set the session as recurring'),
              ),

              const SizedBox(height: 30),

              // Save button
              ElevatedButton.icon(
                onPressed: _saveSession,
                //icon: const Icon(Icons.save),
                label: const Text('Create Session'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
