import 'package:flutter/material.dart';
import 'product.dart';

class CartPage extends StatelessWidget {
  final Map<String, bool> selectedItem;
  final List<Product> menuItems;

  CartPage({required this.selectedItem, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    List<Product> selectedProducts = menuItems.where((item) => selectedItem[item.name] == true).toList();

    double totalPrice = selectedProducts.fold(0.0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart - Total: \$${totalPrice.toStringAsFixed(2)}'),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: selectedProducts.isEmpty
            ? Center(child: Text('No items in the cart'))
            : ListView.builder(
          itemCount: selectedProducts.length,
          itemBuilder: (context, index) {
            var item = selectedProducts[index];
            return Card(
              child: ListTile(
                leading: Image.network(
                  item.image,
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                ),
                title: Text(item.name),
                subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
