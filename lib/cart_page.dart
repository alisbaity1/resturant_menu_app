import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  final Map<String, bool> selectedItem;
  final List<Map<String, dynamic>> menuItems;

  CartPage({required this.selectedItem, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> cartItems = menuItems
        .where((item) => selectedItem[item['name']] ?? false)
        .toList();

    double totalPrice = cartItems.fold(
      0.0,
          (sum, item) => sum + item['price'],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Price: \$${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                var item = cartItems[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      item['name'],
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Text(
                      '\$${item['price'].toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
