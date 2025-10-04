import 'package:flutter/material.dart';
import 'package:my_music/core/utils/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Music'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          '¡Bienvenido a tu app de música!',
          style: TextStyle(
            color: AppColors.pureWhite,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}