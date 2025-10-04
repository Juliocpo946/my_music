import 'package:flutter/material.dart';
import 'package:my_music/core/utils/app_theme.dart';
import 'package:my_music/features/home/presentation/pages/home_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Music',
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}