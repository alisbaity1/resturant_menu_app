import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  bool _loading = false;
  String _message = '';

  Future<void> _addProduct() async {
    setState(() {
      _loading = true;
      _message = '';
    });

    final response = await http.post(
      Uri.parse('http://your_server/add_product.php'), // Replace with your server URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'image': _imageController.text,
      }),
    );

    final data = jsonDecode(response.body);

    setState(() {
      _loading = false;
      _message = data['message'];
    });

    if (data['success']) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
              ),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _imageController,
              decoration: InputDecoration(
                labelText: 'Image URL',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _addProduct,
              child: _loading ? CircularProgressIndicator() : Text('Add Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
              ),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(
                color: _message.contains('success') ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
