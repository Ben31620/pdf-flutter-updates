import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(NovatecApp());
}

class NovatecApp extends StatelessWidget {
  const NovatecApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Novatec',
      theme: ThemeData(
        primaryColor: Color(0xFF177FA8),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Color(0xFFF4B400),
        ),
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: HomeScreen(),
    );
  }
}
