part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  final String path;

  HomeSuccess(this.path);
}

final class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
