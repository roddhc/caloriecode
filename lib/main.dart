//lib/main.dart

import 'package:flutter/material.dart';

void main() {
  runApp(const CalorieCodeApp());
}

class CalorieCodeApp extends StatelessWidget {
  const CalorieCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalorieCode',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('CalorieCode'),
        ),
      ),
    );
  }
}
