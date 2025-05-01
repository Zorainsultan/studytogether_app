import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studytogether_app/pages/user_profileDialog.dart';

class SearchPartnersPage extends StatefulWidget {
  const SearchPartnersPage({super.key});

  @override
  State<SearchPartnersPage> createState() => _SearchPartnersPageState();
}

class _SearchPartnersPageState extends State<SearchPartnersPage> {
  final currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';

  bool _submitted = false;
  bool _loaded = false;

  String? _selectedUniversity;
  String? _selectedCourse;

  Set<String> universityOptions = {};
  Set<String> courseOptions = {};

  //Gets all university and course values from firestore
  //and adds them to the dropdown options
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

  //query to get users based on selected university and course
  Stream<QuerySnapshot> _getFilteredUsers() {
    return FirebaseFirestore.instance
        .collection('Users')
        .where('university', isEqualTo: _selectedUniversity)
        .where('major', isEqualTo: _selectedCourse)
        .snapshots();
  }

  //when no users are found this message is shown
  Widget _buildNoUsersFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No users found. Please try a different filter or try again later.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(248, 199, 14, 14),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadFilterOptions();
  }

//Main UI of the page
  @override
  Widget build(BuildContext context) {
    return PopScope(
      //go back to the filter page if the back button is pressed
      canPop: !_submitted,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _submitted) {
          setState(() {
            _submitted = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F8),
        appBar: AppBar(
          title: const Text('Find Study Partners'),
          backgroundColor: Colors.blue[900],
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,

          //show Home icon only on results screen
          actions: _submitted
              ? [
                  IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () => Navigator.pop(context),
                  ),
                ]
              : null,
        ),
        body: !_submitted
            ? _loaded
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //section title
                        Text(
                          'Search Filters',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        const SizedBox(height: 16),

                        //dropdown for university
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

                        //dropdown for course
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

                        //search button
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[900],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            onPressed: () {
                              if (_selectedUniversity != null &&
                                  _selectedCourse != null) {
                                setState(() {
                                  _submitted = true;
                                });
                              }
                            },
                            child: const Text('Find Partners'),
                          ),
                        ),
                      ],
                    ),
                  )

                //loading spinner while collecting options
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading options...'),
                      ],
                    ),
                  )
            : StreamBuilder<QuerySnapshot>(
                stream: _getFilteredUsers(),
                builder: (context, snapshot) {
                  //loading spinner while getting users
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  //If no users found
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildNoUsersFound();
                  }

                  //Get the user documents
                  final users = snapshot.data!.docs;

                  //List all users except the signed-in user
                  final filteredUsers = users.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return data['email'] != currentUserEmail;
                  }).toList();

                  if (filteredUsers.isEmpty) {
                    return _buildNoUsersFound();
                  }

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      //Show each matched user
                      ...filteredUsers.map((doc) {
                        final userData = doc.data() as Map<String, dynamic>;
                        final name = userData['fullName'] ?? 'Unknown';
                        final university =
                            userData['university'] ?? 'Unknown University';
                        final course = userData['major'] ?? 'Unknown Course';

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.person,
                                size: 30, color: Colors.blue),
                            title: Text(name),
                            subtitle: Text('$university\n$course'),
                            isThreeLine: true,

                            //when tapped, show user details
                            onTap: () {
                              final email = userData['email'] ?? 'N/A';
                              final level = userData.containsKey('level')
                                  ? userData['level']
                                  : 'N/A';
                              final bio = userData['bio'];

                              print(
                                  'Tapped on: $name'); // Debug: confirm tap works

                              ShowUserProfileDialog.show(
                                context: context,
                                fullName: name,
                                email: email,
                                university: university,
                                course: course,
                                studyLevel: level,
                                bio: bio,
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
