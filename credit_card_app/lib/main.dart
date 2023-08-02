import 'package:flutter/material.dart';
import 'my_home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Credit Card Validation', // Title of the application
      theme: ThemeData(
        primarySwatch: Colors.purple, // Define primary color swatch for the app
        scaffoldBackgroundColor:
            Colors.deepPurple[50], // Set lighter purple background for scaffold
      ),
      home: MyHomePage(), // Set MyHomePage as the initial page to be displayed
    );
  }
}
