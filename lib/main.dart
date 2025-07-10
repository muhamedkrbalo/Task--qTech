import 'package:flutter/material.dart';

import 'package:step_counter/core/theme/app_theme.dart';
import 'package:step_counter/features/home/presentation/view/screen/home_screen.dart';
import 'package:step_counter/service_intialize.dart';

void main() async {
  await ServiceInitialize.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
