import 'package:flutter/material.dart';
import 'package:minisns/view/start_up/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:minisns/view/screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mini SNS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginPage(),
    );
  }
}
