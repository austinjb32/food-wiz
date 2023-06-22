import 'package:FoodWiz/screens/home/home_screen.dart';
import 'package:FoodWiz/screens/onboarding/onboding_screen.dart';
import 'package:FoodWiz/screens/search/search_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_products.dart';
import 'constants.dart';

class MyApp extends StatelessWidget {
  final bool isAuthenticated;

  const MyApp({Key? key, required this.isAuthenticated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agape',
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        primarySwatch: Colors.blue,
        fontFamily: "Gordita",
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.black54),
        ),
      ),
      home: OnbodingScreen(),
    );
  }
}

Future<bool> performAuthenticationCheck() async {
  User? user = FirebaseAuth.instance.currentUser;
  return user != null;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Perform authentication check
  bool isAuthenticated = await performAuthenticationCheck();

  runApp(MyApp(isAuthenticated: isAuthenticated));
}