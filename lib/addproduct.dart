import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  String _message = '';
  bool _passwordVerified = false;

  Future<void> _verifyPassword() async {
    setState(() {
      _loading = true;
      _message = '';
    });

    final password = _passwordController.text.trim();

    if (password != 'sbeity@123') {
      setState(() {
        _loading = false;
        _message = 'Invalid password.';
      });
      return;
    }

    setState(() {
      _passwordVerified = true;
      _loading = false;
      _message = '';
    });
  }

  Future<void> _addProduct() async {
    setState(() {
      _loading = true;
      _message = '';
    });

    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    final image = _imageController.text.trim();

    if (name.isEmpty || price == null || image.isEmpty) {
      setState(() {
        _loading = false;
        _message = 'Please fill in all fields correctly.';
      });
      return;
    }

    final response = await addProduct(name, price, image, 'sbeity@123');
    setState(() {
      _loading = false;
      _message = response['message'];
    });

    if (response['status'] == 'success') {
      Navigator.pop(context);
    }
  }

  Future<Map<String, dynamic>> addProduct(String name, double price, String image, String password) async {
    final url = Uri.https('menuitems.onlinewebshop.net', '/addProduct.php');

    // Trust all certificates (development only)
    HttpOverrides.global = new MyHttpOverrides();

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, dynamic>{
          'name': name,
          'price': price,
          'image': image,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return convert.jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Server error: ${response.statusCode}"};
      }
    } catch (e) {
      print("Connection error: $e");
      return {"status": "error", "message": "Connection error: $e"};
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
            if (!_passwordVerified) ...[
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Enter Admin Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _verifyPassword,
                child: _loading ? CircularProgressIndicator() : Text('Verify Password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                ),
              ),
              SizedBox(height: 20),
            ] else ...[
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
            ],
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
