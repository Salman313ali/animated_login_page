import 'package:animated_login_page/firebase_options.dart';
import 'package:animated_login_page/pages/auth_page.dart';
import 'package:animated_login_page/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffb04863)),
        useMaterial3: true,
      ),
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 239, 239, 239), // Starting color
              Color.fromARGB(255, 251, 227, 253), // Starting color
              Color.fromARGB(255, 225, 225, 255), // Ending color
              Color.fromARGB(255, 239, 239, 239),
            ],
          ),
        ),
        child: const AuthPage(),
      ),
    );
  }
}
