abstract class SettingsRepository {
  Future<void> saveUserName(String name);
  Future<String?> getUserName();
  Future<void> saveGenres(List<String> genres);
  Future<List<String>> getGenres();
  Future<void> completeOnboarding();
  Future<bool> isOnboardingComplete();
  Future<void> saveAccentColor(int colorValue);
  Future<int?> getAccentColor();
}