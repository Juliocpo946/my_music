import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music/core/providers/settings_provider.dart';
import 'package:my_music/core/utils/app_colors.dart';
import 'package:my_music/core/utils/app_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod
class AccentColorNotifier extends _$AccentColorNotifier {
  @override
  Future<Color> build() async {
    final repository = ref.watch(settingsRepositoryProvider);
    final colorValue = await repository.getAccentColor();
    if (colorValue != null) {
      return Color(colorValue);
    }
    return AppColors.electricBlue;
  }

  Future<void> updateColor(Color color) async {
    final repository = ref.read(settingsRepositoryProvider);
    await repository.saveAccentColor(color.toARGB32());
    state = AsyncValue.data(color);
  }
}

@riverpod
ThemeData appTheme(Ref ref) {
  final accentColor = ref.watch(accentColorNotifierProvider);
  return AppTheme.darkTheme(accentColor.value ?? AppColors.electricBlue);
}