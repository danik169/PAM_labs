import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/models/app_data.dart';
import 'package:learning_app/data/repositories/course_repository.dart';
import 'package:learning_app/features/courses/cubit/courses_cubit.dart';
import 'package:learning_app/features/courses/cubit/courses_state.dart';

/// Repository fals: întoarce datele imediat (sau aruncă o eroare).
class FakeCourseRepository implements CourseRepository {
  FakeCourseRepository({this.fail = false});

  final bool fail;

  @override
  Future<AppData> loadAppData() async {
    if (fail) throw const DataLoadException('boom');
    return loadTestData();
  }
}

/// Citește chiar fișierul JSON din proiect (testele rulează din rădăcina proiectului).
AppData loadTestData() {
  final raw = File('assets/data/lab_v4.json').readAsStringSync();
  return AppData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}

void main() {
  group('AppData.fromJson', () {
    test('parses home data and the course catalog', () {
      final data = loadTestData();

      expect(data.home.greeting, 'Hi, Kristin');
      expect(data.home.plan.length, 2);
      expect(data.courses.length, 12);
      expect(data.courses.first.id, 'react-front-to-back');
      expect(data.courses.first.lessons.length, 7);
      expect(data.courses.first.isFree, isTrue);
    });
  });

  group('CoursesCubit', () {
    late CoursesCubit cubit;

    setUp(() {
      cubit = CoursesCubit(FakeCourseRepository());
    });

    tearDown(() => cubit.close());

    test('starts in Loading, then goes to Success', () async {
      expect(cubit.state.status, CoursesStatus.loading);

      await cubit.load();

      expect(cubit.state.status, CoursesStatus.success);
      expect(cubit.state.visibleCourses.length, 12);
    });

    test('goes to Error when the repository fails', () async {
      final failing = CoursesCubit(FakeCourseRepository(fail: true));
      addTearDown(failing.close);

      await failing.load();

      expect(failing.state.status, CoursesStatus.error);
      expect(failing.state.errorMessage, 'boom');
    });

    test('search filters the list and goes to Empty when nothing matches',
        () async {
      await cubit.load();

      cubit.search('flutter');
      expect(cubit.state.status, CoursesStatus.success);
      expect(cubit.state.visibleCourses.length, 1);
      expect(cubit.state.visibleCourses.first.id, 'flutter-mobile-apps');

      cubit.search('zzzzzz');
      expect(cubit.state.status, CoursesStatus.empty);
      expect(cubit.state.visibleCourses, isEmpty);

      cubit.clearFilters();
      expect(cubit.state.status, CoursesStatus.success);
      expect(cubit.state.visibleCourses.length, 12);
    });

    test('filters by category', () async {
      await cubit.load();

      cubit.selectCategory('Design');

      expect(cubit.state.visibleCourses, isNotEmpty);
      expect(
        cubit.state.visibleCourses.every((c) => c.category == 'Design'),
        isTrue,
      );

      cubit.selectCategory(null);
      expect(cubit.state.visibleCourses.length, 12);
    });

    test('sorts by rating (descending) and by title (A-Z)', () async {
      await cubit.load();

      cubit.setSort(CourseSort.ratingDesc);
      final ratings = cubit.state.visibleCourses.map((c) => c.rating).toList();
      for (var i = 1; i < ratings.length; i++) {
        expect(ratings[i - 1] >= ratings[i], isTrue);
      }

      cubit.setSort(CourseSort.titleAsc);
      final titles = cubit.state.visibleCourses
          .map((c) => c.title.toLowerCase())
          .toList();
      final sorted = List<String>.of(titles)..sort();
      expect(titles, sorted);
    });

    test('adds and removes favorites, and filters favorites only', () async {
      await cubit.load();

      cubit.toggleFavorite('python-for-data');
      expect(cubit.state.isFavorite('python-for-data'), isTrue);

      cubit.toggleFavoritesOnly();
      expect(cubit.state.visibleCourses.length, 1);
      expect(cubit.state.visibleCourses.first.id, 'python-for-data');

      // Scoaterea ultimului favorit lasă lista goală.
      cubit.toggleFavorite('python-for-data');
      expect(cubit.state.isFavorite('python-for-data'), isFalse);
      expect(cubit.state.status, CoursesStatus.empty);
    });
  });
}
