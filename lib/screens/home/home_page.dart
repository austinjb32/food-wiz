  import 'package:FoodWiz/constants.dart';
  import 'package:FoodWiz/screens/details/components/orders.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';

  import '../../add_products.dart';
  import '../details/components/cartpage.dart';
  import '../details/profile.dart';
  import '../favourites/favourite_page.dart';
  import 'home_screen.dart';

  class MyHomePage extends StatefulWidget {
    const MyHomePage({Key? key}) : super(key: key);

    @override
    _MyHomePageState createState() => _MyHomePageState();
  }

  class _MyHomePageState extends State<MyHomePage> {
    int _currentIndex = 0;

    final List<Widget> _pages = [
      HomeScreen(
        isAuthenticated: true,
      ),
      AddProductPage(),
      FavoritesPage(),
      OrdersPage(),
      ProfilePage()
    ];

    void _onTabTapped(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.black,
          backgroundColor: Colors.black,
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.heart_fill),
              label: 'Favourites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_travel),
              label: 'Order',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2),
              label: 'Profile',
            ),
          ],
        ),
      );
    }
  }
