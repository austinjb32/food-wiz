import 'dart:io';
import 'package:FoodWiz/constants.dart';
import 'package:FoodWiz/screens/home/components/categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final CollectionReference productsCollection =
  FirebaseFirestore.instance.collection('products');
  final FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController imageController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Category? selectedCategory;

  File? _pickedImage;

  @override
  void dispose() {
    imageController.dispose();
    titleController.dispose();
    priceController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedImageFile =
    await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedImageFile == null) return;

    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });
  }

  Future<Map<String, String>> _uploadImageToFirebase(File imageFile) async {
    final firebase_storage.Reference storageRef =
    firebase_storage.FirebaseStorage.instance.ref().child('product_images');

    final metadata =
    firebase_storage.SettableMetadata(contentType: 'image/jpeg');

    final resizedImageSmall = img.copyResize(
        img.decodeImage(imageFile.readAsBytesSync())!,
        width: 200,
        height: 200);

    final temporaryDirectory = await getTemporaryDirectory();
    final resizedImagePathSmall =
        '${temporaryDirectory.path}/${DateTime.now().millisecondsSinceEpoch}_small.jpg';
    File(resizedImagePathSmall)
      ..writeAsBytesSync(img.encodeJpg(resizedImageSmall));

    final resizedImageFileSmall = File(resizedImagePathSmall);
    final storageRefSmall =
    storageRef.child('small_${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTaskSmall =
    storageRefSmall.putFile(resizedImageFileSmall, metadata);
    final snapshotSmall = await uploadTaskSmall.whenComplete(() {});

    String downloadUrlSmall;
    if (snapshotSmall.state == firebase_storage.TaskState.success) {
      downloadUrlSmall = await storageRefSmall.getDownloadURL();
    } else {
      throw ('Small image upload failed. Please try again later.');
    }

    final resizedImageLarge = img.copyResize(
        img.decodeImage(imageFile.readAsBytesSync())!,
        width: 400,
        height: 300);

    final resizedImagePathLarge =
        '${temporaryDirectory.path}/${DateTime.now().millisecondsSinceEpoch}_large.jpg';
    File(resizedImagePathLarge)
      ..writeAsBytesSync(img.encodeJpg(resizedImageLarge));

    final resizedImageFileLarge = File(resizedImagePathLarge);
    final storageRefLarge =
    storageRef.child('large_${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTaskLarge =
    storageRefLarge.putFile(resizedImageFileLarge, metadata);
    final snapshotLarge = await uploadTaskLarge.whenComplete(() {});

    String downloadUrlLarge;
    if (snapshotLarge.state == firebase_storage.TaskState.success) {
      downloadUrlLarge = await storageRefLarge.getDownloadURL();
    } else {
      throw ('Large image upload failed. Please try again later.');
    }

    return {
      'urlSmall': downloadUrlSmall,
      'urlLarge': downloadUrlLarge,
    };
  }

  void addProductToDatabase() async {
    String imageUrl = imageController.text;
    String title = titleController.text;
    int price = int.tryParse(priceController.text) ?? 0;
    int quantity = int.tryParse(quantityController.text) ?? 0;
    String description = descriptionController.text;

    try {
      if (_pickedImage != null) {
        final Map<String, String> imageDownloadUrls =
        await _uploadImageToFirebase(_pickedImage!);
        String imageUrlSmall = imageDownloadUrls['urlSmall'] ?? '';
        String imageUrlLarge = imageDownloadUrls['urlLarge'] ?? '';

        final User? user = auth.currentUser;
        // Get the current user's ID or implement your own logic to get the user ID
        String userId =
            user?.uid ?? ''; // Replace with your logic to get the user ID

        await productsCollection.add({
          'userId': userId, // Add the userId field
          'imageSmall': imageUrlSmall,
          'imageLarge': imageUrlLarge,
          'title': title,
          'price': price,
          'quantity': quantity,
          'category': selectedCategory?.title ?? '',
          'description': description,
        });
      }

      // Clear the text controllers and reset selectedCategory and _pickedImage
      imageController.clear();
      titleController.clear();
      priceController.clear();
      quantityController.clear();
      descriptionController.clear();
      setState(() {
        selectedCategory = null;
        _pickedImage = null;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Product added to the database.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to add product to the database.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      print('Error adding product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Product'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FloatingActionButton.extended(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.upload),
                  label: const Text('Upload Image'),
                  backgroundColor: primaryColor,
                ),
                if (_pickedImage != null)
                  Image.file(
                    _pickedImage!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                DropdownButtonFormField<Category>(
                  value: selectedCategory,
                  items: demoCategories
                      .map<DropdownMenuItem<Category>>((Category category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            category.icon,
                            height: 24,
                            width: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(category.title),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (Category? value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 30.0),
                FloatingActionButton.large(
                  onPressed: addProductToDatabase,
                  child: const Icon(Icons.cloud_upload),
                  backgroundColor: primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
