import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants.dart';
import '../screens/details/details_screen.dart';

class Product {
  final String imageSmall;
  final String imageLarge;
  final String title;
  final int price;
  final String category;
  final String description;
  final String userId;
  final int quantity;
  final String id;

  Product({
    required this.id,
    required this.imageSmall,
    required this.imageLarge,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    required this.userId,
    required this.quantity,
  });

  String? get productId => null;
}

class NewArrivalPage extends StatefulWidget {
  final int selectedCategoryIndex;

  const NewArrivalPage({
    Key? key,
    required this.selectedCategoryIndex,
    required List<QueryDocumentSnapshot<Object?>> products,
  }) : super(key: key);

  @override
  _NewArrivalPageState createState() => _NewArrivalPageState();
}

class _NewArrivalPageState extends State<NewArrivalPage> {
  final CollectionReference productsCollection =
  FirebaseFirestore.instance.collection('products');

  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      QuerySnapshot productsSnapshot = await productsCollection.get();
      List<Product> fetchedProducts = productsSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        int quantity = data['quantity'] ?? 0;

        return Product(
          id: doc.id, // Assigning Firestore document ID as the product ID
          imageSmall: data['imageSmall'] ?? '',
          imageLarge: data['imageLarge'] ?? '',
          title: data['title'] ?? '',
          price: data['price'] ?? 0,
          category: data['category'] ?? '',
          description: data['description'] ?? '',
          userId: data['userId'],
          quantity: quantity,
        );
      }).toList();

      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = [];
    if (widget.selectedCategoryIndex >= 0 &&
        widget.selectedCategoryIndex < demoCategories.length) {
      String selectedCategory =
          demoCategories[widget.selectedCategoryIndex].title;
      filteredProducts = products
          .where((product) => product.category == selectedCategory)
          .where((product) => product.quantity != 0)
          .toList();
    } else {
      filteredProducts = products;
    }

    return GridView.builder(
      padding: const EdgeInsets.all(defaultPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: defaultPadding,
        crossAxisSpacing: defaultPadding,
        childAspectRatio: 0.75,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        Product product = filteredProducts[index];
        return ProductCard(
          product: product,
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(product: product),
              ),
            );
          },
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product,
    required this.press,
  }) : super(key: key);

  final Product product;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: 154,
        padding: const EdgeInsets.all(defaultPadding / 2),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius:
                BorderRadius.all(Radius.circular(defaultBorderRadius)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                child: Image.network(
                  product.imageSmall,
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            Expanded(
              child: Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: defaultPadding / 4),
            Text(
              '\₹ ' + product.price.toString(),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}
