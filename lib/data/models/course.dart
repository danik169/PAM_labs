import 'package:equatable/equatable.dart';

import 'lesson.dart';

/// Un curs din catalog. Acesta este elementul listei din aplicație
/// (căutare, filtrare, sortare, favorite, pagină de detalii).
class Course extends Equatable {
  const Course({
    required this.id,
    required this.title,
    required this.category,
    required this.level,
    required this.duration,
    required this.durationMinutes,
    required this.lessonCount,
    required this.rating,
    required this.accentValue,
    required this.iconKey,
    required this.heroLabel,
    required this.videoCount,
    required this.classCount,
    required this.description,
    required this.priceLabel,
    required this.priceAmount,
    required this.lessons,
  });

  final String id;
  final String title;
  final String category;
  final String level;
  final String duration;
  final int durationMinutes;
  final int lessonCount;
  final double rating;

  /// Culoarea de accent ca valoare ARGB (model independent de Flutter).
  final int accentValue;
  final String iconKey;
  final String heroLabel;
  final int videoCount;
  final int classCount;
  final String description;
  final String priceLabel;
  final double priceAmount;
  final List<Lesson> lessons;

  bool get isFree => priceAmount == 0;

  /// [json] are aceeași structură atât pentru `courseOverviewPage.course`,
  /// cât și pentru elementele din `coursesPage.items`.
  /// Prețul vine din [price] (pentru overview, din `actions.price`)
  /// sau, dacă lipsește, din cheia `price` a cursului.
  factory Course.fromJson(
    Map<String, dynamic> json, {
    Map<String, dynamic>? price,
  }) {
    final hero =
        (json['hero'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
    final priceJson = price ??
        (json['price'] as Map<String, dynamic>?) ??
        const <String, dynamic>{};
    final descriptionJson = json['description'];
    final lessonsJson =
        (json['lessons'] as List<dynamic>?) ?? const <dynamic>[];
    final lessons = lessonsJson
        .map((item) => Lesson.fromJson(item as Map<String, dynamic>))
        .toList();
    final title = json['title'] as String;

    return Course(
      id: json['id'] as String,
      title: title,
      category: json['category'] as String? ?? 'General',
      level: json['level'] as String? ?? 'Beginner',
      duration: json['duration'] as String? ?? '',
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      lessonCount: (json['lessonCount'] as num?)?.toInt() ?? lessons.length,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      accentValue: _parseColor(json['accent'] as String?),
      iconKey: json['icon'] as String? ?? 'school',
      heroLabel: hero['label'] as String? ?? title.toUpperCase(),
      videoCount: (hero['videoCount'] as num?)?.toInt() ?? 0,
      classCount: (hero['classCount'] as num?)?.toInt() ?? 0,
      description: descriptionJson is Map<String, dynamic>
          ? (descriptionJson['text'] as String? ?? '')
          : '',
      priceLabel: priceJson['label'] as String? ?? 'Free',
      priceAmount: (priceJson['amount'] as num?)?.toDouble() ?? 0.0,
      lessons: lessons,
    );
  }

  /// "#RRGGBB" -> 0xFFRRGGBB
  static int _parseColor(String? hex) {
    const fallback = 0xFF465BFA;
    if (hex == null || hex.length != 7 || !hex.startsWith('#')) {
      return fallback;
    }
    return int.tryParse('FF${hex.substring(1)}', radix: 16) ?? fallback;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        level,
        duration,
        durationMinutes,
        lessonCount,
        rating,
        accentValue,
        iconKey,
        heroLabel,
        videoCount,
        classCount,
        description,
        priceLabel,
        priceAmount,
        lessons,
      ];
}
