import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Product {
  final String name;
  final double price;
  final String image;

  Product({required this.name, required this.price, required this.image});

  static List<Product> products = [];

  static Future<void> getNamePrice(Function(bool success) update) async {
    String _baseUrl = 'menuitems.onlinewebshop.net';
    final url = Uri.http(_baseUrl, '/getNamePrice.php');
    final response = await http.get(url).timeout(const Duration(seconds: 5));
    products.clear(); // clear old products

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        Product p = Product(
          name: row['name'],
          price: double.parse(row['price']),
          image: row['image'], // Set the default or placeholder image URL
        );
        products.add(p);
      }
      update(true);
    } else {
      update(false);
    }
  }
  }