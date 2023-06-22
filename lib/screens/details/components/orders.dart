import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersPage extends StatelessWidget {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
        foregroundColor: Colors.black87,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              final data = document.data() as Map<String, dynamic>;
              final category = data['category'];
              final description = data['description'];
              final imageLarge = data['imageLarge'];
              final imageSmall = data['imageSmall'];
              final price = data['price'];
              final quantity = data['quantity'];
              final title = data['title'];
              final userId = data['userId'];
              final productId=data['productId'];

              return ListTile(
                title: Text(title),
                subtitle: Text(productId,textScaleFactor: 0.65,),
                leading: Image.network(imageSmall),
                trailing: Text('\$${price.toString()}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
