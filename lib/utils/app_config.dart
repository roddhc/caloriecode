import 'constants.dart';

/// Application configuration and feature flags.
class AppConfig {
  AppConfig._();

  // Network Configuration
  static const int apiTimeoutMs = Constants.offApiTimeoutMs;
  static const int usdaApiTimeoutMs = Constants.usdaApiTimeoutMs;

  // Default Values
  static const int defaultScanHistoryLimit = 50;
  static const String defaultLanguageCode = 'en';

  // Feature Flags
  static const bool enableUsdaApiFallback = true;
  static const bool enableOcrScanning = false;
  static const bool showAds = false;
}
