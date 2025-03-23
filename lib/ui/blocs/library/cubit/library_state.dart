part of 'library_bloc.dart';

@immutable
sealed class LibraryState {}

final class LibraryInitial extends LibraryState {}

final class LibraryLoading extends LibraryState {}

final class LibrarySuccess extends LibraryState {
  final List<String> paths;

  LibrarySuccess(this.paths);
}

final class LibraryError extends LibraryState {
  final String message;

  LibraryError(this.message);
}

final class LibraryDeleteSuccess extends LibraryState {}

final class LibraryPlaying extends LibraryState {
  final String path;

  LibraryPlaying(this.path);
}

final class LibraryPaused extends LibraryState {
  final String path;

  LibraryPaused(this.path);
}
