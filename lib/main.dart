import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:studytogether_app/auth/login_or_register.dart';
import 'package:studytogether_app/pages/login_page.dart';
import 'package:studytogether_app/pages/profile_page.dart';
import 'package:studytogether_app/pages/register_page.dart';
import 'package:studytogether_app/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyTogether',
      home: const LoginOrRegister(),
      routes: {
        '/profile': (context) => ProfilePage(),
        '/home': (context) => const HomePage(),
        '/session': (context) => const Placeholder(), // TODO
        '/search': (context) => const Placeholder(), // TODO
        '/chat': (context) => const Placeholder(), // TODO
      },
    );
  }
}
