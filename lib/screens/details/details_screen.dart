import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';
import '../../models/pro.dart' as details;

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

  String get productId => id;

  int get productQuantity => quantity;
}

class DetailsScreen extends StatefulWidget {
  final details.Product product;

  const DetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isFavorite = false;
  int quantity = 1; // Track the quantity of the product

  Future<void> toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoriteRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites');

      if (isFavorite) {
        favoriteRef.doc(widget.product.id).delete();
      } else {
        favoriteRef.doc(widget.product.id).set({
          'id': widget.product.id,
          'title': widget.product.title,
          'price': widget.product.price,
          'description': widget.product.description,
          'quantity': widget.product.quantity,
          'imageLarge': widget.product.imageLarge,
        });
      }

      setState(() {
        isFavorite = !isFavorite;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  Future<void> checkIfFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoriteRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites');

      final favoriteSnapshot = await favoriteRef.doc(widget.product.id).get();
      setState(() {
        isFavorite = favoriteSnapshot.exists;
      });
    }
  }

  Future<void> addToCart(details.Product product) async {
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
      final currentStock = product.quantity;
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
            onPressed: toggleFavorite,
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                "assets/icons/Heart.svg",
                height: 20,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Image.network(
            widget.product.imageLarge,
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
                          widget.product.title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      const SizedBox(width: defaultPadding),
                      Text(
                        "\₹ " + widget.product.price.toString(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Text(widget.product.description ?? ''),
                  ),
                  Text(
                    "Quantity",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) {
                              quantity--;
                            }
                          });
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        quantity.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (quantity < widget.product.quantity) {
                              quantity++;
                            }
                          });
                        },
                        icon: const Icon(Icons.add),
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
                          addToCart(widget.product);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Successfully Added to Cart"),
                                content: TextButton(
                                  child: Text("OK"),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              );
                            },
                          );
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
