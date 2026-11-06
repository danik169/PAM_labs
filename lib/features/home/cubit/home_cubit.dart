import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/course_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeState.loading());

  final CourseRepository _repository;

  /// Încarcă asincron datele ecranului Home din JSON.
  Future<void> load() async {
    emit(const HomeState.loading());
    try {
      final data = await _repository.loadAppData();
      if (isClosed) return;
      emit(HomeState.success(data.home));
    } catch (e) {
      if (isClosed) return;
      emit(HomeState.error(e.toString()));
    }
  }
}
