// add_page.dart
import 'package:flutter/material.dart';
import 'dashboard.dart'; // Import the Dashboard page here
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var detailsController = TextEditingController();
  var priceController = TextEditingController();
  var quantityController = TextEditingController();
  File? _image;

  Future<void> addProduct() async {
    var request = http.MultipartRequest('POST', Uri.parse('http://localhost:3000/api/produitsroute/produit'));
    request.fields['name'] = nameController.text;
    request.fields['details'] = detailsController.text;
    request.fields['price'] = priceController.text;
    request.fields['quantity'] = quantityController.text;
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Product added successfully');
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardPage(),
      ),
    );
    } else {
      throw Exception('Failed to add product');
    }
  }

  Future<void> getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: detailsController,
              decoration: const InputDecoration(labelText: 'Details'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: getImage,
              child: const Text('Select Image'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() && _image != null) {
                  addProduct();
                }
              },
              child: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}