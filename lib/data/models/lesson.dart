import 'package:equatable/equatable.dart';

/// O lecție dintr-un curs (`courseOverviewPage.course.lessons[]` în JSON).
class Lesson extends Equatable {
  const Lesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.durationSeconds,
    required this.completed,
    required this.locked,
  });

  final String id;
  final String title;
  final String duration;
  final int durationSeconds;
  final bool completed;
  final bool locked;

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      duration: json['duration'] as String? ?? '',
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      completed: json['completed'] as bool? ?? false,
      locked: json['locked'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, duration, durationSeconds, completed, locked];
}
