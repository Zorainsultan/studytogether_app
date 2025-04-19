import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:studytogether_app/auth/login_or_register.dart';
import 'package:studytogether_app/pages/login_page.dart';
import 'package:studytogether_app/pages/register_page.dart';

//entry point of the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //run the app
  runApp(MyApp());
}

//root widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyTogether',
      home: LoginOrRegister(),
    );
  }
}
