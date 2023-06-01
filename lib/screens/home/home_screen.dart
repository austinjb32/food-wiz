import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stylish/constants.dart';
import 'package:stylish/screens/home/components/categories.dart';

import '../../models/Product.dart';
import 'new_arrival_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _selectedCategoryIndex = 0;

  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Navigator.pushNamed(context, '/search');
    } else {
      // Handle other tab selections
    }
  }

  void _handleCategorySelection(Category category) {
    setState(() {
      _selectedCategoryIndex = demoCategories.indexOf(category);
    });
  }

  @override
  Widget build(BuildContext context) {
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
            icon: Icon(Icons.shopping_cart,color: Colors.grey,),
            onPressed: () {
              _handleNavigation(1);
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
              onCategorySelected: _handleCategorySelection,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: NewArrivalPage(selectedCategoryIndex: _selectedCategoryIndex),
            ),
            // Add your other widgets here
          ],
        ),
      ),
    );
  }
}
