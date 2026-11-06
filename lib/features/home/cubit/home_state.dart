import 'package:equatable/equatable.dart';

import '../../../data/models/home_data.dart';

enum HomeStatus { loading, success, error }

class HomeState extends Equatable {
  const HomeState._({required this.status, this.data, this.errorMessage});

  const HomeState.loading() : this._(status: HomeStatus.loading);

  const HomeState.success(HomeData data)
      : this._(status: HomeStatus.success, data: data);

  const HomeState.error(String message)
      : this._(status: HomeStatus.error, errorMessage: message);

  final HomeStatus status;
  final HomeData? data;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, data, errorMessage];
}
