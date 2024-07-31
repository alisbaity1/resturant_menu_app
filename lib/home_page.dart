import 'package:flutter/material.dart';
import 'product.dart';
import 'cart_page.dart';
import 'register.dart';
import 'login.dart';
import 'addproduct.dart'; // Import the add product page
import 'package:url_launcher/url_launcher.dart'; // Add this dependency to your pubspec.yaml
import 'logout.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  String _errorMessage = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Define selectedItem as a Map to manage selection state
  Map<String, bool> selectedItem = {};

  @override
  void initState() {
    super.initState();
    Product.getNamePrice((success) {
      setState(() {
        _loading = false;
        if (success) {
          for (var item in Product.products) {
            selectedItem[item.name] = false;
          }
        } else {
          _errorMessage = 'Failed to load products';
        }
      });
    });
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Restaurant Menu'),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(
                    selectedItem: selectedItem,
                    menuItems: Product.products,
                  ),
                ),
              );
            },
          ),

        ],
      ),
      drawer: Drawer(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5, // Half the screen width
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Text('Add Product'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddProductPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LogoutPage()),
                  );
                },
              ),

            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey.shade300],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                  MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: Product.products.length,
                itemBuilder: (context, index) {
                  var item = Product.products[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedItem[item.name] =
                        !selectedItem[item.name]!;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedItem[item.name]!
                            ? Colors.blue.withOpacity(0.3)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              child: Image.network(
                                item.image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: selectedItem[item.name]!
                                        ? Colors.blue
                                        : Colors.black,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${item.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: selectedItem[item.name]!
                                            ? Colors.blue
                                            : Colors.black,
                                      ),
                                    ),
                                    Checkbox(
                                      value: selectedItem[item.name],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          selectedItem[item.name] = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Footer
          Container(
            color: Colors.lightBlue,
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chat, color: Colors.white),
                      onPressed: () {
                        _launchURL('https://wa.me/76761664'); // Replace with your WhatsApp number
                      },
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      icon: Icon(Icons.facebook, color: Colors.white),
                      onPressed: () {
                        _launchURL('https://www.facebook.com/hassan.sbeity.35'); // Replace with your Facebook page URL
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
