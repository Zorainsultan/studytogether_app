import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studytogether_app/pages/search_results.dart';

// This page allows users to search for study partners based on their
// university and course. It fetches unique universities and courses from
// the Firestore database and displays them in dropdown menus.
class SearchPartnersPage extends StatefulWidget {
  const SearchPartnersPage({super.key});

  @override
  State<SearchPartnersPage> createState() => _SearchPartnersPageState();
}

class _SearchPartnersPageState extends State<SearchPartnersPage> {
  bool _loaded = false;
  String? _selectedUniversity;
  String? _selectedCourse;

  Set<String> universityOptions = {};
  Set<String> courseOptions = {};

  // Fetch unique universities and courses from Users collection.
  Future<void> _loadFilterOptions() async {
    final snapshot = await FirebaseFirestore.instance.collection('Users').get();
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final uni = data['university'];
      final course = data['major'];
      if (uni != null && uni.toString().trim().isNotEmpty) {
        universityOptions.add(uni);
      }
      if (course != null && course.toString().trim().isNotEmpty) {
        courseOptions.add(course);
      }
    }
    setState(() {
      _loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFilterOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Find Study Partners'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: _loaded
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Information card explaining how to use the filter
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
                              'Please select a university and course from the dropdowns below to find students who matched your selected criteria.\n\nOnly students registered in the app will appear in the results.',
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
                  const SizedBox(height: 24),

                  // University dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedUniversity,
                    decoration: const InputDecoration(
                      labelText: 'University',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                    items: universityOptions
                        .map((uni) => DropdownMenuItem(
                              value: uni,
                              child: Text(uni),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedUniversity = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Course dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedCourse,
                    decoration: const InputDecoration(
                      labelText: 'Course',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.book_outlined),
                    ),
                    items: courseOptions
                        .map((course) => DropdownMenuItem(
                              value: course,
                              child: Text(course),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCourse = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Search button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      // Find partners button
                      // When pressed, navigate to the search results page
                      // if one of the dropdowns is not selected, show a snackbar
                      // with a message to select both university and course

                      onPressed: () {
                        if (_selectedUniversity != null &&
                            _selectedCourse != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchResultsPage(
                                university: _selectedUniversity!,
                                course: _selectedCourse!,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please select both university and course.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: const Text('Find Students'),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading universities and courses...'),
                ],
              ),
            ),
    );
  }
}
