import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../cart.dart';

class AddToCartPage extends StatelessWidget {
  final String cartItemId;

  const AddToCartPage({required this.cartItemId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('cart')
          .doc(cartItemId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final cartItemData = snapshot.data!.data() as Map<String, dynamic>;

        if (cartItemData.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add to Cart'),
            ),
            body: const Center(
              child: Text('No items in cart'),
            ),
          );
        }

        final imageUrl = cartItemData['imageUrl'] as String;
        final title = cartItemData['title'] as String;
        final price = cartItemData['price'] as double;
        final quantity = cartItemData['quantity'] as int;

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Add to Cart'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      imageUrl,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Price: \₹ ${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Quantity: $quantity',
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      CartService.addToCart(cartItemId); // Add to cart functionality
                      print('Order now');
                    },
                    child: const Text('Order Now'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
