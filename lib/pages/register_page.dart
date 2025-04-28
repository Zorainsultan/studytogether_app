import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studytogether_app/uiComponents/my_textfield.dart';
import 'package:studytogether_app/helper/alert_helper.dart';
import 'package:studytogether_app/pages/home_page.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final fullNameController = TextEditingController();
  final uniNameController = TextEditingController();
  final emailController = TextEditingController();
  final majorController = TextEditingController();
  final passwordController = TextEditingController();
  final levelController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  // List of some UK university names (add more when needed)
  final List<String> universityList = [
    'University of Oxford',
    'University of Cambridge',
    'Imperial College London',
    'University College London (UCL)',
    'London School of Economics (LSE)',
    'King’s College London',
    'University of Manchester',
    'University of Birmingham',
    'University of Edinburgh',
    'University of Nottingham',
    'City, University of London',
  ];

  void registerUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    if (passwordController.text != confirmpasswordController.text) {
      if (context.mounted) Navigator.pop(context);

      displayMessageToUser(
        "Both the passwords entered do not match. Please make sure they are identical.",
        context,
        title: "Error",
      );
      return;
    }

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      //create user document and add to firestore
      createUserDocument(userCredential);

      if (context.mounted) Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      if (context.mounted) Navigator.pop(context);

      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = "This email is already registered.";
          break;
        case 'invalid-email':
          message = "Please enter a valid email address.";
          break;
        case 'weak-password':
          message = "Password should be at least 6 characters long.";
          break;
        default:
          message = "Something went wrong. Please try again.";
      }

      displayMessageToUser(message, context);
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      displayMessageToUser("An unexpected error occurred.", context);
    }
  }

  // Function to create user document in Firestore
  Future<void> createUserDocument(UserCredential userCredential) async {
    // Assuming you have a Firestore instance and a users collection
    final user = userCredential.user;
    if (user != null) {
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
        'fullName': fullNameController.text,
        'email': emailController.text,
        'university': uniNameController.text,
        'major': majorController.text,
        'level': levelController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo or heading
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('assets/images/LogoF.png', height: 80),
                    const SizedBox(height: 10),
                    Text(
                      'Create your StudyTogether account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Let’s get you set up and ace in your studies!',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              Text(
                'Your Details',
                style: TextStyle(
                  color: Colors.blueGrey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: fullNameController,
                hintText: 'Full Name',
                obscureText: false,
              ),
              const SizedBox(height: 20),

              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 30),
              Text(
                'University Info',
                style: TextStyle(
                  color: Colors.blueGrey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 0),

              Padding(
                padding: EdgeInsets.all(20), // helped me change the box size
                child: TypeAheadFormField<String>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: uniNameController,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Name of University',
                      filled: true,
                      fillColor: Colors.grey[200],
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    return universityList.where((uni) =>
                        uni.toLowerCase().contains(pattern.toLowerCase()));
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    uniNameController.text = suggestion;
                  },
                  noItemsFoundBuilder: (context) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        uniNameController.text = uniNameController.text;
                      },
                      child: Text(
                        'Not listed? Tap to keep "${uniNameController.text}"',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.blueGrey),
                      ),
                    ),
                  ),
                ),
              ),

              MyTextField(
                controller: majorController,
                hintText: 'Course Enrolled',
                obscureText: false,
              ),
              const SizedBox(height: 20),

              MyTextField(
                controller: levelController,
                hintText: 'Study Level (e.g. Undergraduate)',
                obscureText: false,
              ),

              const SizedBox(height: 30),
              Text(
                'Set Password',
                style: TextStyle(
                  color: Colors.blueGrey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),

              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 20),

              MyTextField(
                controller: confirmpasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),

              const SizedBox(height: 40),
              GestureDetector(
                onTap: registerUser,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Login here',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 49, 89),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
