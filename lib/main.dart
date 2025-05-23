import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:studytogether_app/auth/login_or_register.dart';
import 'package:studytogether_app/pages/accepted_partners.dart';
import 'package:studytogether_app/pages/chat.dart';
import 'package:studytogether_app/pages/profile_page.dart';
import 'package:studytogether_app/pages/home_page.dart';
import 'package:studytogether_app/pages/study_sessionHome.dart';
import 'package:studytogether_app/pages/create_session.dart';
import 'package:studytogether_app/pages/join_session.dart';
import 'package:studytogether_app/pages/search_studyPartners.dart';

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
        '/find': (context) => const SearchPartnersPage(),
        //'/chat': (context) => ChatPage(
        //     otherUserId: '1234',
        //    otherUserName: 'Zorain Sultan',
        //    ),
        '/partners': (context) => const AcceptedPartnersPage(),
      },
    );
  }
}

// Done! :)
