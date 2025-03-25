import 'dart:io';

import 'package:baixa_tube/core/enums/enums.dart';
import 'package:baixa_tube/core/widgets/modals/modal_primary.dart';
import 'package:baixa_tube/ui/models/song_model.dart';
import 'package:baixa_tube/ui/repositories/local_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

part 'library_state.dart';

class LibraryBloc extends Cubit<LibraryState> {
  LibraryBloc() : super(LibraryInitial());

  final player = AudioPlayer();
  final local = LocalRepository();

  void getSounds(BuildContext context) async {
    emit(LibraryLoading());
    final result = await local.getData(LocalDataKey.songs.name);
    if (result != null) {
      final songs = result.map((e) => SongModel.fromJson(e)).toList();
      emit(LibrarySuccess(songs: songs, isPlaying: false));
      setCurrentSound(songs, songs[0]);
    } else {
      emit(LibraryError('Nenhuma música encontrada'));
    }
  }

  void setCurrentSound(List<SongModel> songs, SongModel? songModel) {
    emit(LibrarySuccess(songs: songs, isPlaying: false, currentSong: songModel));
    playSound(songs, songModel);
  }

  void playSound(List<SongModel> songs, SongModel? songModel) async {
    if (songModel == null) return;
    try {
      await player.setAsset(songModel.path);
      player.play();
      emit(LibrarySuccess(songs: songs, isPlaying: true, currentSong: songModel));
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }

  void pauseSound(List<SongModel> songs, SongModel? songModel) async {
    try {
      await player.pause();
      emit(LibrarySuccess(songs: songs, isPlaying: false, currentSong: songModel));
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }

  void nextSound(List<SongModel> songs, SongModel? songModel) async {
    pauseSound(songs, songModel);
    if (songModel == null) return;
    final index = songs.indexOf(songModel);
    if (index == songs.length - 1) {
      playSound(songs, songs.first);
    } else {
      playSound(songs, songs[index + 1]);
    }
  }

  void previousSound(List<SongModel> songs, SongModel? songModel) async {
    pauseSound(songs, songModel);
    if (songModel == null) return;
    final index = songs.indexOf(songModel);
    if (index == 0) {
      playSound(songs, songs.last);
    } else {
      playSound(songs, songs[index - 1]);
    }
  }

  void deleteSound(List<SongModel> songs, SongModel songModel, BuildContext context) async {
    bool confirmation = false;

    await ModalPrimary.confirmationModal(
      context: context,
      onConfirm: () => confirmation = true,
    );

    final result = await local.getData(LocalDataKey.songs.name);
    if (result != null && confirmation) {
      final list = result.map((e) => SongModel.fromJson(e)).toList();
      list.removeWhere((element) => element.path == songModel.path);

      final jsonList = list.map((song) => song.toJson()).toList();
      await local.saveData(LocalDataKey.songs.name, jsonList);

      final file = File(songModel.path);
      if (await file.exists()) {
        await file.delete();
      }
      emit(LibrarySuccess(songs: list, isPlaying: false));
    }
  }
}
