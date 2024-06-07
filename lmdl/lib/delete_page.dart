// delete_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dashboard.dart'; 


class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  List<dynamic> products = [];
  var selectedProduct;

  Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/produitsroute/produit'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> deleteProduct() async {
  final response = await http.delete(Uri.parse('http://localhost:3000/api/produitsroute/produit/${selectedProduct['pid']}'));
  if (response.statusCode == 200) {
    setState(() {
      products.remove(selectedProduct);
      selectedProduct = null;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardPage(),
      ),
    );
  } else {
    throw Exception('Failed to delete product');
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
        title: const Text('Delete Product'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          DropdownButton(
            value: selectedProduct,
            items: products.map((product) {
              return DropdownMenuItem(
                value: product,
                child: Text(product['name']),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedProduct = newValue;
              });
            },
          ),
          ElevatedButton(
            onPressed: selectedProduct != null ? deleteProduct : null,
            child: const Text('Delete Product'),
          ),
        ],
      ),
    );
  }
}