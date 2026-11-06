import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/debouncer.dart';
import '../../../core/widgets/category_chips.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/state_views.dart';
import '../../course_details/view/course_details_screen.dart';
import '../cubit/courses_cubit.dart';
import '../cubit/courses_state.dart';
import '../widgets/course_card.dart';
import '../widgets/sort_menu.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const CoursesScreen());
  }

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Căutarea se aplică după 350 ms de la ultima literă tastată.
  final Debouncer _debouncer = Debouncer(const Duration(milliseconds: 350));

  @override
  void dispose() {
    _debouncer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final cubit = context.read<CoursesCubit>();
    _debouncer.run(() => cubit.search(value));
  }

  void _clearSearch() {
    _debouncer.cancel();
    _searchController.clear();
    context.read<CoursesCubit>().search('');
  }

  void _clearFilters() {
    _debouncer.cancel();
    _searchController.clear();
    context.read<CoursesCubit>().clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.screenBg,
        body: SafeArea(
          child: BlocBuilder<CoursesCubit, CoursesState>(
            builder: (context, state) {
              final loaded = state.status == CoursesStatus.success ||
                  state.status == CoursesStatus.empty;
              final cubit = context.read<CoursesCubit>();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopBar(
                    enabled: loaded,
                    sort: state.sort,
                    favoritesOnly: state.favoritesOnly,
                    onSortSelected: cubit.setSort,
                    onToggleFavorites: cubit.toggleFavoritesOnly,
                  ),
                  if (loaded) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SearchField(
                        controller: _searchController,
                        hint: 'Search courses',
                        onChanged: _onSearchChanged,
                        onClear: _clearSearch,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CategoryChips(
                      categories: state.categories,
                      selected: state.selectedCategory,
                      onSelected: cubit.selectCategory,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                      child: Text(
                        '${state.visibleCourses.length} of '
                        '${state.allCourses.length} courses',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textGray,
                        ),
                      ),
                    ),
                  ],
                  Expanded(child: _buildBody(context, state)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CoursesState state) {
    switch (state.status) {
      case CoursesStatus.loading:
        return const LoadingView(message: 'Loading courses...');

      case CoursesStatus.error:
        return ErrorView(
          message: state.errorMessage ?? 'Something went wrong.',
          onRetry: () => context.read<CoursesCubit>().load(),
        );

      case CoursesStatus.empty:
        final onlyFavorites = state.favoritesOnly &&
            state.query.trim().isEmpty &&
            state.selectedCategory == null;
        return EmptyView(
          icon: onlyFavorites ? Icons.favorite_border : Icons.search_off,
          title: onlyFavorites ? 'No favorites yet' : 'No courses found',
          message: onlyFavorites
              ? 'Tap the heart on a course to add it to your favorites.'
              : state.hasActiveFilters
                  ? 'Try a different search or clear the filters.'
                  : 'There are no courses available right now.',
          actionLabel: state.hasActiveFilters ? 'Clear filters' : null,
          onAction: state.hasActiveFilters ? _clearFilters : null,
        );

      case CoursesStatus.success:
        return ListView.separated(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          itemCount: state.visibleCourses.length,
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final course = state.visibleCourses[index];
            return CourseCard(
              key: ValueKey<String>(course.id),
              course: course,
              isFavorite: state.isFavorite(course.id),
              onTap: () {
                Navigator.of(context).push(CourseDetailsScreen.route(course));
              },
              onFavoriteTap: () {
                context.read<CoursesCubit>().toggleFavorite(course.id);
              },
            );
          },
        );
    }
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.enabled,
    required this.sort,
    required this.favoritesOnly,
    required this.onSortSelected,
    required this.onToggleFavorites,
  });

  final bool enabled;
  final CourseSort sort;
  final bool favoritesOnly;
  final ValueChanged<CourseSort> onSortSelected;
  final VoidCallback onToggleFavorites;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: AppColors.textDark,
            ),
          ),
          const Expanded(
            child: Text(
              'My courses',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ),
          IconButton(
            onPressed: enabled ? onToggleFavorites : null,
            tooltip: favoritesOnly ? 'Show all courses' : 'Show only favorites',
            icon: Icon(
              favoritesOnly ? Icons.favorite : Icons.favorite_border,
              color: favoritesOnly ? AppColors.red : AppColors.textDark,
            ),
          ),
          SortMenu(
            enabled: enabled,
            selected: sort,
            onSelected: onSortSelected,
          ),
        ],
      ),
    );
  }
}
