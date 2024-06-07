// edit_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  List<dynamic> products = [];
  Map<String, dynamic>? selectedProduct;
  var nameController = TextEditingController();
  var detailsController = TextEditingController();
  var priceController = TextEditingController();
  var quantityController = TextEditingController();

  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/produitsroute/produit'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts().then((value) => setState(() {
      products = value;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modify Product'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            DropdownButton(
              value: selectedProduct,
              hint: const Text('Select a product'),
              items: products.map((product) {
                return DropdownMenuItem(
                  value: product,
                  child: Text(product['name']),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedProduct = newValue as Map<String, dynamic>?;
                  if (selectedProduct != null) {
                    nameController.text = selectedProduct!['name'] ?? '';
                    detailsController.text = selectedProduct!['details'] ?? '';
                    priceController.text = selectedProduct!['price']?.toString() ?? '';
                    quantityController.text = selectedProduct!['quantity']?.toString() ?? '';
                  } else {
                    nameController.clear();
                    detailsController.clear();
                    priceController.clear();
                    quantityController.clear();
                  }
                });
              },
            ),
            // ... rest of the code
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Implement the submit logic
                  print('Product modified');
                }
              },
              child: const Text('Modify Product'),
            ),
          ],
        ),
      ),
    );
  }
}