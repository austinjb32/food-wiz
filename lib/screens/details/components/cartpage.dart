import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../constants.dart';
import '../../home/payments.dart';

class CartProduct {
  final String productId;
  int quantity;

  CartProduct({
    required this.productId,
    required this.quantity,
  });
}

class Product {
  final String productId;
  final String name;
  final int price;
  final String imageUrl;

  Product({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CollectionReference cartCollection =
  FirebaseFirestore.instance.collection('users');
  final CollectionReference productCollection =
  FirebaseFirestore.instance.collection('products');
  final CollectionReference orderCollection =
  FirebaseFirestore.instance.collection('orders');

  List<CartProduct> cartProducts = [];
  List<Product> fetchedProducts = [];
  late int totalAmount = 0;
  late String username;

  @override
  void initState() {
    super.initState();
    fetchCartProducts();
  }

  void updateTotalAmount() {
    totalAmount = fetchedProducts.fold(0, (sum, product) {
      final cartProduct = cartProducts.firstWhere(
              (cartProduct) => cartProduct.productId == product.productId);
      return sum + (cartProduct.quantity * product.price);
    });
  }

  Future<void> fetchCartProducts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartRef = cartCollection.doc(user.uid).collection('cart');
      final cartSnapshot = await cartRef.get();

      final List<CartProduct> fetchedCartProducts = [];
      for (final doc in cartSnapshot.docs) {
        final productId = doc.id;
        final quantity = doc.data()['quantity'] ?? 0;

        fetchedCartProducts.add(
          CartProduct(productId: productId, quantity: quantity),
        );
      }

      setState(() {
        cartProducts = fetchedCartProducts;
      });

      final List<Product> fetchedProductInfo = [];
      for (final cartProduct in cartProducts) {
        final productDoc =
        await productCollection.doc(cartProduct.productId).get();
        if (productDoc.exists) {
          final productData = productDoc.data() as Map<String, dynamic>?;

          final product = Product(
            productId: productDoc.id,
            name: productData?['title'] as String? ?? '',
            price: productData?['price'] ?? 0,
            imageUrl: productData?['imageSmall'] as String? ?? '',
          );
          fetchedProductInfo.add(product);
        }
      }

      setState(() {
        fetchedProducts = fetchedProductInfo;
        updateTotalAmount();
      });

      // Retrieve user's username from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final userData = userDoc.data() as Map<String, dynamic>?;

      setState(() {
        username = userData?['username'] as String? ?? '';
      });
    }
  }

  String generateRandomNumber() {
    Random random = Random();
    int randomNumber = random.nextInt(99999999 - 10000000) + 100000000000;
    return randomNumber.toString();
  }

  void doPaymentAndPlaceOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Create an order document in Firestore
      final orderCollection = FirebaseFirestore.instance.collection('orders');
      final orderData = {
        'category': fetchedProducts[0].name, // Example: Taking the category from the first product
        'description': 'work', // Example: Static description
        'imageLarge': fetchedProducts[0].imageUrl, // Example: Taking the image URL from the first product
        'imageSmall': fetchedProducts[0].imageUrl, // Example: Taking the image URL from the first product
        'price': totalAmount,
        'quantity': fetchedProducts[0].price, // Example: Taking the price from the first product
        'title': fetchedProducts[0].name, // Example: Taking the title from the first product
        'userId': user.uid,
        'productId': generateRandomNumber(),
      };

      final orderRef = await orderCollection.add(orderData);

      // Remove items from cart collection
      final cartRef = cartCollection.doc(user.uid).collection('cart');
      for (final cartProduct in cartProducts) {
        cartRef.doc(cartProduct.productId).delete();
      }

      // Clear cart products and fetched products list
      setState(() {
        cartProducts.clear();
        fetchedProducts.clear();
        totalAmount = 0;
      });

      // Navigate to payments page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Payments(// Pass the order ID to the payments page
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Your Cart",
          textScaleFactor: 1.2,
        ),
        foregroundColor: Colors.black87,
      ),
      body: cartProducts.isEmpty
          ? const Center(
        child: Text('No items found in the cart.'),
      )
          : Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: fetchedProducts.length,
              itemBuilder: (context, index) {
                final cartProduct = cartProducts[index];
                final product = fetchedProducts[index];

                int itemTotal = cartProduct.quantity * product.price;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Image.network(
                      product.imageUrl,
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '${product.name}',
                            textScaleFactor: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            if (cartProduct.quantity > 1) {
                              setState(() {
                                cartProduct.quantity--;
                                updateTotalAmount();
                                itemTotal -= product.price;
                              });
                            }
                          },
                        ),
                        Text('${cartProduct.quantity}'),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              cartProduct.quantity++;
                              updateTotalAmount();
                              itemTotal += product.price;
                            });
                          },
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₹ ${product.price}',
                          textScaleFactor: 1,
                          style:
                          TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          iconSize: 15,
                          onPressed: () {
                            removeItemFromCart(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            'Total Amount: INR $totalAmount',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            onPressed: doPaymentAndPlaceOrder,
            child: Icon(Icons.shopping_bag),
            isExtended: true,
            backgroundColor: primaryColor,
          ),
        ],
      ),
    );
  }

  void removeItemFromCart(int index) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartRef = cartCollection.doc(user.uid).collection('cart');
      final product = fetchedProducts[index];

      // Get the product document reference from the product collection
      final productRef = productCollection.doc(product.productId);
      final productDoc = await productRef.get();

      if (productDoc.exists) {
        // If the product already exists, update the quantity in the product collection
        final existingQuantity =
            productDoc.data() as Map<String, dynamic>? ?? {};
        final int? quantity = existingQuantity['quantity'] as int?;
        if (quantity != null) {
          await productRef.update({'quantity': quantity + 1});
        }
      } else {
        // If the product doesn't exist, move it from the cart collection to the product collection
        final cartItemDoc = await cartRef.doc(product.productId).get();
        if (cartItemDoc.exists) {
          final cartItemData =
              cartItemDoc.data() as Map<String, dynamic>? ?? {};
          await productRef.set(cartItemData);
        }
      }

      // Delete the item from the cart collection
      await cartRef.doc(product.productId).delete();

      setState(() {
        cartProducts.removeAt(index);
        fetchedProducts.removeAt(index);
        updateTotalAmount();
      });
    }
  }
}
