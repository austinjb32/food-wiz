import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stylish/constants.dart';
import 'package:stylish/screens/home/home_screen.dart';
import 'package:stylish/screens/onboarding/onboding_screen.dart';
import 'package:stylish/screens/search/search_widget.dart';

import 'add_products.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Flutter Way',
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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const OnbodingScreen(),
        '/': (context) => BottomNavigationWrapper(
          child: const HomeScreen(),
        ),
        '/search': (context) => BottomNavigationWrapper(
          child: const SearchPage(),
        ),
        '/add': (context) => BottomNavigationWrapper(
          child: const AddProductPage(),
        ),
        // Add your other routes here
      },
    );
  }
}

class BottomNavigationWrapper extends StatefulWidget {
  final Widget child;

  const BottomNavigationWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _BottomNavigationWrapperState createState() => _BottomNavigationWrapperState();
}

class _BottomNavigationWrapperState extends State<BottomNavigationWrapper> {
  int _currentIndex = 0;

  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Perform navigation based on the selected tab
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/search');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/add');
        break;
    // Add more cases for other tabs
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the current route's name
    final currentRoute = ModalRoute.of(context)?.settings.name;

    // Update the current index based on the route
    if (currentRoute == '/') {
      _currentIndex = 0;
    } else if (currentRoute == '/search') {
      _currentIndex = 1;
    } else if (currentRoute == '/add') {
      _currentIndex = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the current route is the onboarding screen
    final isOnboardingScreen = ModalRoute.of(context)?.settings.name == '/login';

    // Return the appropriate layout based on the current route
    if (isOnboardingScreen) {
      return Scaffold(body: widget.child);
    } else {
      return Scaffold(
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _handleNavigation,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add), // Add this line
              label: 'Add', // Update the label as desired
            ),
          ],
        ),
      );
    }
  }
}
