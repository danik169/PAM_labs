import 'package:equatable/equatable.dart';

import 'course.dart';
import 'home_data.dart';

/// Tot ce se citește din fișierul JSON.
class AppData extends Equatable {
  const AppData({required this.home, required this.courses});

  final HomeData home;
  final List<Course> courses;

  /// Lista de cursuri = cursul din `courseOverviewPage` (primul)
  /// + restul catalogului din `coursesPage.items`.
  factory AppData.fromJson(Map<String, dynamic> json) {
    final home = HomeData.fromJson(json['homePage'] as Map<String, dynamic>);

    final overviewPage = json['courseOverviewPage'] as Map<String, dynamic>;
    final actions = overviewPage['actions'] as Map<String, dynamic>?;
    final overviewPrice = actions?['price'] as Map<String, dynamic>?;
    final overviewCourse = Course.fromJson(
      overviewPage['course'] as Map<String, dynamic>,
      price: overviewPrice,
    );

    final coursesPage = json['coursesPage'] as Map<String, dynamic>?;
    final catalogJson = (coursesPage?['items'] as List<dynamic>?) ?? const <dynamic>[];
    final catalog = catalogJson
        .map((item) => Course.fromJson(item as Map<String, dynamic>))
        .where((course) => course.id != overviewCourse.id);

    return AppData(home: home, courses: [overviewCourse, ...catalog]);
  }

  @override
  List<Object?> get props => [home, courses];
}
