import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  static Future<void> addToCart(String cartItemId) async {
    final cartItemRef =
    FirebaseFirestore.instance.collection('cart').doc(cartItemId);

    final cartItemDoc = await cartItemRef.get();

    if (cartItemDoc.exists) {
      final cartItemData = cartItemDoc.data() as Map<String, dynamic>;
      final quantity = cartItemData['quantity'] as int;

      await cartItemRef.update({'quantity': quantity + 1});
    } else {
      // Handle the case where the cart item does not exist
    }
  }
}
