import 'package:flutter/material.dart';
import 'product.dart';

class CartPage extends StatefulWidget {
  final Map<String, bool> selectedItem;
  final List<Product> menuItems;

  CartPage({required this.selectedItem, required this.menuItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Map to hold the quantity of each product
  Map<String, int> quantities = {};

  @override
  void initState() {
    super.initState();
    // Initialize quantities for selected items
    for (var item in widget.menuItems) {
      if (widget.selectedItem[item.name] == true) {
        quantities[item.name] = 1; // Default quantity is 1
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get selected products
    List<Product> selectedProducts = widget.menuItems.where((item) => widget.selectedItem[item.name] == true).toList();

    // Calculate total price
    double totalPrice = selectedProducts.fold(0.0, (sum, item) => sum + (item.price * (quantities[item.name] ?? 1)));

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
                subtitle: Row(
                  children: [
                    Text('\$${item.price.toStringAsFixed(2)} x '),
                    Text('${quantities[item.name] ?? 1}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (quantities[item.name]! > 1) {
                            quantities[item.name] = quantities[item.name]! - 1;
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          quantities[item.name] = (quantities[item.name] ?? 1) + 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
