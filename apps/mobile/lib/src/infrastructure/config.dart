class AppConfig {
  final String defaultLlmModel;
  final String quantizationProfile;
  final bool isOfflineMode;

  const AppConfig({
    this.defaultLlmModel = 'qwen3-0.6b-instruct-q4_k_m',
    this.quantizationProfile = 'Q4_K_M',
    this.isOfflineMode = true,
  });
}
