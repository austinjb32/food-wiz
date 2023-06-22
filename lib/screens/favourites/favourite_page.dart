import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/pro.dart' as details;

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoriteRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites');

      return Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: favoriteRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final favoriteDocs = snapshot.data!.docs;
              if (favoriteDocs.isNotEmpty) {
                return ListView.builder(
                  itemCount: favoriteDocs.length,
                  itemBuilder: (context, index) {
                    final favoriteData =
                    favoriteDocs[index].data() as Map<String, dynamic>;
                    final favoriteProduct = details.Product(
                      id: favoriteData['id'] ?? '',
                      title: favoriteData['title'] ?? '',
                      price: favoriteData['price'] ?? 0.0,
                      description: favoriteData['description'] ?? '',
                      quantity: favoriteData['quantity'] ?? 0,
                      imageSmall: favoriteData['imageSmall'] ?? '',
                      imageLarge: favoriteData['imageLarge'] ?? '',
                      category: favoriteData['category'] ?? '',
                      userId: favoriteData['userId'] ?? '',
                    );
                    return ListTile(
                      title: Text(favoriteProduct.title),
                      leading: Image(
                        image: NetworkImage(favoriteProduct.imageLarge),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      subtitle: Text("Price: ₹ ${favoriteProduct.price}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          favoriteRef.doc(favoriteProduct.id).delete();
                        },
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text("No favorites yet."),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );
    } else {
      return Center(
        child: Text("User not logged in."),
      );
    }
  }
}
