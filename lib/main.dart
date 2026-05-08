import 'package:flutter/material.dart';
import 'screens/home_shell.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const HomeShell(),
    );
  }
}
