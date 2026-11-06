import 'package:equatable/equatable.dart';

/// Un element din "Learning Plan" (`homePage.learningPlan.items[]`).
class PlanItem extends Equatable {
  const PlanItem({
    required this.id,
    required this.title,
    required this.completed,
    required this.total,
    required this.progress,
  });

  final String id;
  final String title;
  final int completed;
  final int total;
  final double progress;

  factory PlanItem.fromJson(Map<String, dynamic> json) {
    final completed = (json['completed'] as num?)?.toInt() ?? 0;
    final total = (json['total'] as num?)?.toInt() ?? 0;
    return PlanItem(
      id: json['id'] as String,
      title: json['title'] as String,
      completed: completed,
      total: total,
      progress: (json['progress'] as num?)?.toDouble() ??
          (total == 0 ? 0.0 : completed / total),
    );
  }

  @override
  List<Object?> get props => [id, title, completed, total, progress];
}

/// Datele ecranului Home (`homePage` din JSON).
class HomeData extends Equatable {
  const HomeData({
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
    required this.hasUnreadNotifications,
    required this.learnedTitle,
    required this.learnedMinutes,
    required this.goalMinutes,
    required this.learnedProgress,
    required this.myCoursesLabel,
    required this.promptTitle,
    required this.promptActionLabel,
    required this.planTitle,
    required this.plan,
    required this.meetupTitle,
    required this.meetupSubtitle,
  });

  final String greeting;
  final String subtitle;
  final String avatarUrl;
  final bool hasUnreadNotifications;
  final String learnedTitle;
  final int learnedMinutes;
  final int goalMinutes;
  final double learnedProgress;
  final String myCoursesLabel;
  final String promptTitle;
  final String promptActionLabel;
  final String planTitle;
  final List<PlanItem> plan;
  final String meetupTitle;
  final String meetupSubtitle;

  factory HomeData.fromJson(Map<String, dynamic> json) {
    const empty = <String, dynamic>{};
    final header = (json['header'] as Map<String, dynamic>?) ?? empty;
    final notification =
        (header['notification'] as Map<String, dynamic>?) ?? empty;
    final learned = (json['learnedToday'] as Map<String, dynamic>?) ?? empty;
    final myCourses = (json['myCourses'] as Map<String, dynamic>?) ?? empty;
    final prompt = (json['learningPrompt'] as Map<String, dynamic>?) ?? empty;
    final plan = (json['learningPlan'] as Map<String, dynamic>?) ?? empty;
    final meetup = (json['meetup'] as Map<String, dynamic>?) ?? empty;
    final planItems = (plan['items'] as List<dynamic>?) ?? const <dynamic>[];

    final learnedMinutes = (learned['learnedMinutes'] as num?)?.toInt() ?? 0;
    final goalMinutes = (learned['goalMinutes'] as num?)?.toInt() ?? 0;

    return HomeData(
      greeting: header['greeting'] as String? ?? '',
      subtitle: header['subtitle'] as String? ?? '',
      avatarUrl: header['avatarUrl'] as String? ?? '',
      hasUnreadNotifications: notification['hasUnread'] as bool? ?? false,
      learnedTitle: learned['title'] as String? ?? 'Learned today',
      learnedMinutes: learnedMinutes,
      goalMinutes: goalMinutes,
      learnedProgress: (learned['progress'] as num?)?.toDouble() ??
          (goalMinutes == 0 ? 0.0 : learnedMinutes / goalMinutes),
      myCoursesLabel: myCourses['actionLabel'] as String? ?? 'My courses',
      promptTitle: prompt['title'] as String? ?? '',
      promptActionLabel: prompt['actionLabel'] as String? ?? 'Get Started',
      planTitle: plan['title'] as String? ?? 'Learning Plan',
      plan: planItems
          .map((item) => PlanItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      meetupTitle: meetup['title'] as String? ?? '',
      meetupSubtitle: meetup['subtitle'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [
        greeting,
        subtitle,
        avatarUrl,
        hasUnreadNotifications,
        learnedTitle,
        learnedMinutes,
        goalMinutes,
        learnedProgress,
        myCoursesLabel,
        promptTitle,
        promptActionLabel,
        planTitle,
        plan,
        meetupTitle,
        meetupSubtitle,
      ];
}
