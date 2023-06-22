import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class Category {
  final String icon;
  final String title;

  Category({required this.icon, required this.title});
}

List<Category> demoCategories = [
  Category(
    icon: "assets/icons/juice.svg",
    title: "Juices",
  ),
  Category(
    icon: "assets/icons/coffee.svg",
    title: "Caffeine",
  ),
  Category(
    icon: "assets/icons/doughnut.svg",
    title: "Snacks",
  ),
  Category(
    icon: "assets/icons/food.svg",
    title: "Meals",
  ),
];

class Categories extends StatefulWidget {
  final List<Category> categories;
  final void Function(int) onCategorySelected;

  const Categories({
    Key? key,
    required this.categories,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          widget.categories.length,
              (index) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              widget.onCategorySelected(index); // Pass the index here
            },
            child: CategoryCard(
              category: widget.categories[index],
              isSelected: _selectedIndex == index,
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  final bool isSelected;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: primaryColor.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: SvgPicture.asset(
            category.icon,
            color: isSelected ? Colors.white : kTextColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          category.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? primaryColor : kTextColor.withOpacity(0.4),
          ),
        ),
      ],
    );
  }
}
