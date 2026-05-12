import 'package:flutter/material.dart';
import 'screens/home_shell.dart';
import 'utils/design_colors.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: DesignColors.primaryBlue,
          primary: DesignColors.primaryBlue,
          background: DesignColors.backgroundLight,
        ),
        scaffoldBackgroundColor: DesignColors.backgroundLight,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: DesignColors.primaryBlue,
          primary: DesignColors.primaryBlue,
          background: DesignColors.backgroundDark,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: DesignColors.backgroundDark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const HomeShell(),
    );
  }
}
