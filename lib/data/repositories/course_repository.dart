import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../../core/config/app_config.dart';
import '../models/app_data.dart';

/// Eroare la încărcarea sau interpretarea datelor.
class DataLoadException implements Exception {
  const DataLoadException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Contractul sursei de date. Cubit-urile depind de această clasă abstractă,
/// nu de implementarea concretă (se poate înlocui ușor în teste).
abstract class CourseRepository {
  Future<AppData> loadAppData();
}

/// Citește datele din fișierul JSON inclus în proiect (assets), asincron.
class AssetCourseRepository implements CourseRepository {
  AssetCourseRepository({
    AssetBundle? bundle,
    this.latency = AppConfig.loadDelay,
  }) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final Duration latency;

  AppData? _cache;
  Future<AppData>? _inFlight;

  @override
  Future<AppData> loadAppData() {
    final cached = _cache;
    if (cached != null) return Future<AppData>.value(cached);

    // Dacă există deja o încărcare în curs (Home și Courses o cer simultan),
    // o refolosim în loc să citim fișierul de două ori.
    final pending = _inFlight ??= _fetch().whenComplete(() {
      _inFlight = null;
    });
    return pending;
  }

  Future<AppData> _fetch() async {
    await Future<void>.delayed(latency);

    if (AppConfig.simulateError) {
      throw const DataLoadException(
        'Simulated error (AppConfig.simulateError = true).',
      );
    }

    try {
      final raw = await _bundle.loadString(AppConfig.dataAsset);
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final data = AppData.fromJson(decoded);
      _cache = data;
      return data;
    } catch (e) {
      throw DataLoadException('Could not read ${AppConfig.dataAsset}: $e');
    }
  }
}
