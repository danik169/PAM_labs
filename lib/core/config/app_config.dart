/// Setări globale ale aplicației.
class AppConfig {
  const AppConfig._();

  /// Calea fișierului JSON declarat în `pubspec.yaml` (secțiunea assets).
  static const String dataAsset = 'assets/data/lab_v4.json';

  /// Latență simulată la încărcare, ca să se vadă starea **Loading**.
  static const Duration loadDelay = Duration(milliseconds: 1200);

  /// Pune `true` și repornește aplicația (Hot Restart) ca să vezi starea **Error**.
  static bool simulateError = false;
}
