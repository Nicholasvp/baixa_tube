part of 'library_bloc.dart';

@immutable
sealed class LibraryState {}

final class LibraryInitial extends LibraryState {}

final class LibraryLoading extends LibraryState {}

final class LibrarySuccess extends LibraryState {
  final List<SongModel> songs;
  final bool isPlaying;
  final SongModel? currentSong;

  LibrarySuccess({required this.songs, required this.isPlaying, this.currentSong});
}

final class LibraryError extends LibraryState {
  final String message;

  LibraryError(this.message);
}
