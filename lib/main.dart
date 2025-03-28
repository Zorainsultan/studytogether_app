//import flutter's material design widgets
import 'package:flutter/material.dart';
//import the login screen from pages folder
import 'package:studytogether_app/pages/login_page.dart';
import 'pages/login_page.dart';

//entry point of the app
void main() {
  runApp(const MyApp());
}

//root widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyTogether',
      home: LoginPage(),
    );
  }
}
