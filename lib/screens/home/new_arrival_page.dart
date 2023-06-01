// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:stylish/constants.dart';
//
// import '../details/details_screen.dart';
// import 'components/categories.dart';
//
//
// class Product {
//   final String image_small;
//   final String image_large;
//   final String title;
//   final int price;
//   final String category;
//   final String description;
//
//   Product({
//     required this.title,
//     required this.price,
//     required this.category,
//     required this.description, required this.image_small, required this.image_large,
//   });
// }
//
// class NewArrivalPage extends StatefulWidget {
//   final int selectedCategoryIndex;
//
//   const NewArrivalPage({Key? key, required this.selectedCategoryIndex}) : super(key: key);
//
//   @override
//   _NewArrivalPageState createState() => _NewArrivalPageState();
// }
//
// class _NewArrivalPageState extends State<NewArrivalPage> {
//   final CollectionReference productsCollection = FirebaseFirestore.instance.collection('products');
//
//   List<Product> products = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//   }
//
//   Future<void> fetchProducts() async {
//     try {
//       QuerySnapshot productsSnapshot = await productsCollection.get();
//       List<Product> fetchedProducts = productsSnapshot.docs.map((doc) {
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         return Product(
//           image_small: data['imageSmall'] ?? '',
//           image_large:data['imageLarge']?? '',
//           title: data['title'] ?? '',
//           price: data['price'] ?? 0,
//           category: data['category'] ?? '',
//           description: data['description'] ?? '',
//         );
//       }).toList();
//
//       setState(() {
//         products = fetchedProducts;
//       });
//     } catch (e) {
//       print('Error fetching products: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<Product> filteredProducts = [];
//     if (widget.selectedCategoryIndex >= 0 && widget.selectedCategoryIndex < demoCategories.length) {
//       String selectedCategory = demoCategories[widget.selectedCategoryIndex].title;
//       filteredProducts = products.where((product) => product.category == selectedCategory).toList();
//     } else {
//       filteredProducts = products;
//     }
//
//     return GridView.builder(
//       padding: const EdgeInsets.all(defaultPadding),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         mainAxisSpacing: defaultPadding,
//         crossAxisSpacing: defaultPadding,
//         childAspectRatio: 0.75,
//       ),
//       itemCount: filteredProducts.length,
//       itemBuilder: (context, index) {
//         Product product = filteredProducts[index];
//         return ProductCard(
//           image: product.image_small,
//           title: product.title,
//           price: product.price,
//           press: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DetailsScreen(product: product),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
//
// class ProductCard extends StatelessWidget {
//   const ProductCard({
//     Key? key,
//     required this.image,
//     required this.title,
//     required this.price,
//     required this.press,
//   }) : super(key: key);
//
//   final String image;
//   final String title;
//   final int price;
//   final VoidCallback press;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: press,
//       child: Container(
//         width: 154,
//         padding: const EdgeInsets.all(defaultPadding / 2),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
//         ),
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Colors.grey,
//                 borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(defaultBorderRadius),
//                 child: Image.network(
//                   image,
//                   width: 100,
//                   height: 100,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: defaultPadding / 2),
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             const SizedBox(height: defaultPadding / 4),
//             Text(
//               '\$' + price.toString(),
//               style: Theme.of(context).textTheme.subtitle1,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
