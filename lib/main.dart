import 'package:flutter/material.dart';
// Import the HomePage widget from home.dart
import 'home_page.dart';
import 'login.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Menu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(), // Set HomePage as the main screen
      debugShowCheckedModeBanner: false,
    );
  }
}
