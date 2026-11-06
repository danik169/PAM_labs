import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/course.dart';
import '../../../data/repositories/course_repository.dart';
import 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  CoursesCubit(this._repository) : super(const CoursesState());

  final CourseRepository _repository;

  bool get _isLoaded =>
      state.status == CoursesStatus.success ||
      state.status == CoursesStatus.empty;

  /// Încărcare asincronă: Loading -> Success / Empty / Error.
  /// Favoritele deja alese se păstrează la reîncărcare.
  Future<void> load() async {
    emit(CoursesState(favoriteIds: state.favoriteIds));
    try {
      final data = await _repository.loadAppData();
      if (isClosed) return;
      emit(_recompute(state.copyWith(allCourses: data.courses)));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        status: CoursesStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void search(String query) {
    if (!_isLoaded) return;
    emit(_recompute(state.copyWith(query: query)));
  }

  /// `null` = "All".
  void selectCategory(String? category) {
    if (!_isLoaded) return;
    emit(_recompute(
      category == null
          ? state.copyWith(clearCategory: true)
          : state.copyWith(selectedCategory: category),
    ));
  }

  void setSort(CourseSort sort) {
    if (!_isLoaded) return;
    emit(_recompute(state.copyWith(sort: sort)));
  }

  void toggleFavoritesOnly() {
    if (!_isLoaded) return;
    emit(_recompute(state.copyWith(favoritesOnly: !state.favoritesOnly)));
  }

  void clearFilters() {
    if (!_isLoaded) return;
    emit(_recompute(state.copyWith(
      query: '',
      clearCategory: true,
      favoritesOnly: false,
    )));
  }

  /// Adaugă / elimină un curs din favorite.
  void toggleFavorite(String courseId) {
    final ids = Set<String>.of(state.favoriteIds);
    if (!ids.remove(courseId)) ids.add(courseId);
    final next = state.copyWith(favoriteIds: ids);
    emit(_isLoaded ? _recompute(next) : next);
  }

  /// Recalculează lista vizibilă și stabilește starea Success / Empty.
  CoursesState _recompute(CoursesState s) {
    final visible = _applyFilters(s);
    return s.copyWith(
      visibleCourses: visible,
      status: visible.isEmpty ? CoursesStatus.empty : CoursesStatus.success,
    );
  }
}

List<Course> _applyFilters(CoursesState s) {
  final query = s.query.trim().toLowerCase();

  final result = s.allCourses.where((course) {
    if (s.selectedCategory != null && course.category != s.selectedCategory) {
      return false;
    }
    if (s.favoritesOnly && !s.favoriteIds.contains(course.id)) {
      return false;
    }
    if (query.isEmpty) return true;
    return course.title.toLowerCase().contains(query) ||
        course.category.toLowerCase().contains(query) ||
        course.level.toLowerCase().contains(query);
  }).toList();

  int byTitle(Course a, Course b) =>
      a.title.toLowerCase().compareTo(b.title.toLowerCase());

  switch (s.sort) {
    case CourseSort.featured:
      break; // ordinea din JSON
    case CourseSort.titleAsc:
      result.sort(byTitle);
      break;
    case CourseSort.ratingDesc:
      result.sort((a, b) {
        final cmp = b.rating.compareTo(a.rating);
        return cmp != 0 ? cmp : byTitle(a, b);
      });
      break;
    case CourseSort.durationAsc:
      result.sort((a, b) {
        final cmp = a.durationMinutes.compareTo(b.durationMinutes);
        return cmp != 0 ? cmp : byTitle(a, b);
      });
      break;
  }
  return result;
}
