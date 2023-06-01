import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stylish/constants.dart';
import '../../models/product.dart';
import 'components/color_dot.dart';

class Product {
  String id;
  String title;
  double price;
  String description;
  int quantity;
  String imageLarge;

  // Add a constructor to initialize the fields
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.quantity,
    required this.imageLarge,
  });

  // Add getters for 'id' and 'quantity'
  String get productId => id;
  int get productQuantity => quantity;
}

class DetailsScreen extends StatelessWidget {
  final product;

  const DetailsScreen({Key? key, required this.product}) : super(key: key);



  Future<void> addToCart(Product product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart');

      final existingCartItem = await cartRef.doc(product.id).get();
      if (existingCartItem.exists) {
        final quantity = existingCartItem.data()!['quantity'] as int;
        cartRef.doc(product.id).update({'quantity': quantity + 1});
      } else {
        cartRef.doc(product.id).set({'quantity': 1});
      }

      final productRef =
      FirebaseFirestore.instance.collection('products').doc(product.id);
      final currentStock = product.quantity as int;
      productRef.update({'quantity': currentStock - 1});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                "assets/icons/Heart.svg",
                height: 20,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Image.network(
            product.image_large,
            height: MediaQuery.of(context).size.height * 0.4,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: defaultPadding * 1.5),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(defaultPadding,
                  defaultPadding * 2, defaultPadding, defaultPadding),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(defaultBorderRadius * 3),
                  topRight: Radius.circular(defaultBorderRadius * 3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      const SizedBox(width: defaultPadding),
                      Text(
                        "\₹ " + product.price.toString(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Text(product.description ?? ''),
                  ),
                  Text(
                    "Amounts",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Row(
                    children: const [
                      ColorDot(
                        color: Color(0xFFBEE8EA),
                        isActive: false,
                      ),
                      ColorDot(
                        color: Color(0xFF141B4A),
                        isActive: true,
                      ),
                      ColorDot(
                        color: Color(0xFFF4E5C3),
                        isActive: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          addToCart(product);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text("Add to Cart"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
