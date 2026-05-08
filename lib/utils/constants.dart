/// Application-wide constants.
class Constants {
  // Prevent instantiation
  Constants._();

  /// The name of the local SQLite database file.
  static const String databaseName = 'caloriecode.db';

  /// Timeout duration for the Open Food Facts API in milliseconds.
  static const int offApiTimeoutMs = 1500;

  /// Timeout duration for the USDA API in milliseconds.
  static const int usdaApiTimeoutMs = 2000;

  /// The time-to-live (TTL) for cached product data in days.
  static const int cacheTtlDays = 30;
}
