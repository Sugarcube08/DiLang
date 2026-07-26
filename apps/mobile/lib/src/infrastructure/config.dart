class AppConfig {
  final String defaultLlmModel;
  final String quantizationProfile;
  final bool isOfflineMode;

  const AppConfig({
    this.defaultLlmModel = 'gemma-3-1b-it',
    this.quantizationProfile = 'Q4_K_M',
    this.isOfflineMode = true,
  });
}
