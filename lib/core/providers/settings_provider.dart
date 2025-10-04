import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_music/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:my_music/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:my_music/features/settings/domain/repositories/settings_repository.dart';

part 'settings_provider.g.dart';

@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  return SettingsRepositoryImpl(
    localDataSource: SettingsLocalDataSourceImpl(),
  );
}