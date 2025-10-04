import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_music/core/utils/app_colors.dart';

class GenreChip extends StatelessWidget {
  final String name;
  const GenreChip({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/home/genre/${Uri.encodeComponent(name)}'),
      child: Chip(
        label: Text(name),
        backgroundColor: AppColors.darkGrey,
        labelStyle: const TextStyle(color: AppColors.pureWhite),
        side: BorderSide.none,
      ),
    );
  }
}