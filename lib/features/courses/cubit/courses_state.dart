import 'package:equatable/equatable.dart';

import '../../../data/models/course.dart';

/// Cele patru stări principale ale listei.
enum CoursesStatus { loading, success, empty, error }

enum CourseSort { featured, titleAsc, ratingDesc, durationAsc }

extension CourseSortLabel on CourseSort {
  String get label {
    switch (this) {
      case CourseSort.featured:
        return 'Featured';
      case CourseSort.titleAsc:
        return 'Title (A–Z)';
      case CourseSort.ratingDesc:
        return 'Rating (high to low)';
      case CourseSort.durationAsc:
        return 'Duration (short to long)';
    }
  }
}

class CoursesState extends Equatable {
  const CoursesState({
    this.status = CoursesStatus.loading,
    this.allCourses = const <Course>[],
    this.visibleCourses = const <Course>[],
    this.query = '',
    this.selectedCategory,
    this.sort = CourseSort.featured,
    this.favoritesOnly = false,
    this.favoriteIds = const <String>{},
    this.errorMessage,
  });

  final CoursesStatus status;

  /// Toate cursurile încărcate din JSON.
  final List<Course> allCourses;

  /// Cursurile rămase după căutare + filtre + sortare (ce se afișează).
  final List<Course> visibleCourses;

  final String query;

  /// `null` = toate categoriile.
  final String? selectedCategory;
  final CourseSort sort;
  final bool favoritesOnly;
  final Set<String> favoriteIds;
  final String? errorMessage;

  List<String> get categories {
    final unique = allCourses.map((course) => course.category).toSet().toList();
    unique.sort();
    return unique;
  }

  bool get hasActiveFilters =>
      query.trim().isNotEmpty || selectedCategory != null || favoritesOnly;

  bool isFavorite(String courseId) => favoriteIds.contains(courseId);

  CoursesState copyWith({
    CoursesStatus? status,
    List<Course>? allCourses,
    List<Course>? visibleCourses,
    String? query,
    String? selectedCategory,
    bool clearCategory = false,
    CourseSort? sort,
    bool? favoritesOnly,
    Set<String>? favoriteIds,
    String? errorMessage,
  }) {
    return CoursesState(
      status: status ?? this.status,
      allCourses: allCourses ?? this.allCourses,
      visibleCourses: visibleCourses ?? this.visibleCourses,
      query: query ?? this.query,
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      sort: sort ?? this.sort,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allCourses,
        visibleCourses,
        query,
        selectedCategory,
        sort,
        favoritesOnly,
        favoriteIds,
        errorMessage,
      ];
}
