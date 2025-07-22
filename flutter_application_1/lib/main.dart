import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // Add this line

void main() {
  runApp(CurrencyAssistantApp());
}

class CurrencyAssistantApp extends StatelessWidget {
  const CurrencyAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: SplashScreen(), // Change from HomeScreen() to SplashScreen()
    );
  }
}
