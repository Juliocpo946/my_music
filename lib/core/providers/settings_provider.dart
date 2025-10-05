import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';

part 'settings_provider.g.dart';

@riverpod
SettingsRepository settingsRepository(Ref ref) {
  final dataSource = SettingsLocalDataSourceImpl();
  return SettingsRepositoryImpl(localDataSource: dataSource);
}