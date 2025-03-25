part of 'library_bloc.dart';

sealed class LibraryState {
  final List<SongModel>? songs;
  final SongModel? currentSong;
  final bool? isPlaying;

  LibraryState({
    this.songs,
    this.currentSong,
    this.isPlaying,
  });
}

class LibraryInitial extends LibraryState {
  LibraryInitial({super.songs, super.currentSong, super.isPlaying});
}

class LibraryLoading extends LibraryState {
  LibraryLoading({super.songs, super.currentSong, super.isPlaying});
}

class LibrarySuccess extends LibraryState {
  LibrarySuccess({super.songs, super.currentSong, super.isPlaying});
}

class LibraryError extends LibraryState {
  LibraryError({super.songs, super.currentSong, super.isPlaying, required this.message});

  final String message;
}
