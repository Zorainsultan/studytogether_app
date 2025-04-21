import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:studytogether_app/auth/login_or_register.dart';
import 'package:studytogether_app/pages/login_page.dart';
import 'package:studytogether_app/pages/profile_page.dart';
import 'package:studytogether_app/pages/register_page.dart';
import 'package:studytogether_app/pages/home_page.dart';
import 'package:studytogether_app/pages/study_sessionhome.dart';
import 'package:studytogether_app/pages/create_session.dart';
import 'package:studytogether_app/pages/join_session.dart';

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
        '/session': (context) => const StudySessionPage(),
        '/join': (context) => const JoinSessionPage(),
        '/create': (context) => const CreateSessionPage(),
        '/search': (context) => const Placeholder(), // TODO
        '/chat': (context) => const Placeholder(), // TODO
      },
    );
  }
}
