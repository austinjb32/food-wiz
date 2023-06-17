import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stylish/constants.dart';
import 'package:stylish/screens/home/components/categories.dart'; // Import your login screen
import 'package:stylish/screens/onboarding/onboding_screen.dart';

import '../../models/Product.dart';
import 'new_arrival_page.dart';

class HomeScreen extends StatelessWidget {
  final bool isAuthenticated; // Add a parameter to indicate authentication status

  const HomeScreen({Key? key, required this.isAuthenticated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isAuthenticated) {
      return OnbodingScreen(); // Return your login screen if not authenticated
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset("assets/icons/menu.svg"),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset("assets/icons/Notification.svg"),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.grey),
            onPressed: () {
              // Handle cart button pressed
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Explore",
              style: Theme.of(context).textTheme.headline4!.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const Text(
              "Best Dishes for You",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: defaultPadding),
            Categories(
              onCategorySelected: (category) {
                // Handle category selection
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: NewArrivalPage(selectedCategoryIndex: 0),
            ),
            // Add your other widgets here
          ],
        ),
      ),
    );
  }
}
