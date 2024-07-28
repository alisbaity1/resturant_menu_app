import 'package:flutter/material.dart';
import 'product.dart'; // Import the Product class

class CartPage extends StatelessWidget {
  final Map<String, bool> selectedItem;
  final List<Product> menuItems;

  CartPage({required this.selectedItem, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    List<Product> selectedProducts = menuItems.where((item) => selectedItem[item.name]!).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: ListView.builder(
        itemCount: selectedProducts.length,
        itemBuilder: (context, index) {
          var item = selectedProducts[index];
          return ListTile(
            leading: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(item.name),
            subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
