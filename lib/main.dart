import 'package:flutter/material.dart';
import 'home_page.dart';  // Import the HomePage class

void main() {
  runApp(RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Order App',
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
