import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studytogether_app/helper/alert_helper.dart';
import 'package:studytogether_app/uiComponents/my_textfield.dart';

//create a page that user can access when they click on forgot password?.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
// Controller to fetch email input from the user.
  final emailController = TextEditingController();

// Function to reset password.
  void resetPassword() async {
// Loading circle while sending reset password email.
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
// Trying to send password reset email to the email provided by the user.
// If the email is valid, a password reset link will be sent to the email.
// If the email is not valid, an error message will be displayed.
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      if (context.mounted) Navigator.pop(context);
      displayMessageToUser(
        "Password reset link sent! Please check your email.",
        context,
        title: "Success",
      );

// If there is an error, close the loading circle.
    } on FirebaseAuthException catch (e) {
      if (context.mounted) Navigator.pop(context);

// Display error message based on the error code.
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = "No account found with that email.";
          break;
        case 'invalid-email':
          message = "Please enter a valid email address.";
          break;
        default:
          message = "Something went wrong. Try again.";
      }

      displayMessageToUser(message, context);
    }
  }

// UI for the forgot password page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Reset Password"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter your email and we'll send you a password reset link.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Email input
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 20),

            // Reset password button
            GestureDetector(
              onTap: resetPassword,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
