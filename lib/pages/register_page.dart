import 'package:flutter/material.dart';
import 'package:studytogether_app/uiComponents/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

//text controllers for the text fields
  final fullNameController = TextEditingController();
  final uniNameController = TextEditingController();
  final emailController = TextEditingController();
  final majorController = TextEditingController();
  final passwordController = TextEditingController();
  final levelController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  void register() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),

              // FullName entry
              MyTextField(
                controller: fullNameController,
                hintText: 'Full Name',
                obscureText: false,
              ),
              const SizedBox(height: 20),

              // email entry
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 20),

              // Uni name entry
              MyTextField(
                controller: uniNameController,
                hintText: 'Name of University',
                obscureText: false,
              ),
              const SizedBox(height: 20),

              // Course name entry
              MyTextField(
                controller: majorController,
                hintText: 'Course Enrolled',
                obscureText: false,
              ),
              const SizedBox(height: 20),

              // Study Level entry
              MyTextField(
                controller: levelController,
                hintText: 'Study Level (Please select)',
                obscureText: false,
              ),
              const SizedBox(height: 20),

              // password
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              // confirm password
              MyTextField(
                controller: confirmpasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),

              const SizedBox(height: 190),

              // Register button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: () {
                    // TODO: handle login logic here
                    print(
                        'Login pressed. Username: ${emailController.text}, Password: ${passwordController.text}');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue[900], //overall color of the button
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
              ),

              // already a member?, login.
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      'Login here',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 49, 89),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
