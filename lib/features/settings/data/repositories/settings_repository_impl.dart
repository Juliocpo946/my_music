import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<void> completeOnboarding() async {
    await localDataSource.saveSetting('onboardingComplete', 'true');
  }

  @override
  Future<List<String>> getGenres() {
    return localDataSource.getGenres();
  }

  @override
  Future<String?> getUserName() {
    return localDataSource.getSetting('userName');
  }

  @override
  Future<bool> isOnboardingComplete() async {
    final result = await localDataSource.getSetting('onboardingComplete');
    return result == 'true';
  }

  @override
  Future<void> saveGenres(List<String> genres) {
    return localDataSource.saveGenres(genres);
  }

  @override
  Future<void> saveUserName(String name) {
    return localDataSource.saveSetting('userName', name);
  }
}