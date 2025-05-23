import 'package:flutter/material.dart';
import 'package:studytogether_app/pages/login_page.dart';
import 'package:studytogether_app/pages/register_page.dart';

/// A widget that toggles between the login and registration pages.
class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // Initally show login page.
  bool showLoginPage = true;

  // Toggle between login and register page.
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
