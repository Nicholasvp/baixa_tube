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

  final local = LocalRepository();
  final player = AudioPlayer();

  void getSounds() async {
    emit(LibraryLoading());
    final result = await local.getData(LocalDataKey.songs.name);
    if (result != null) {
      final songs = result.map((e) => SongModel.fromJson(e)).toList();
      emit(LibrarySuccess(songs: songs, isPlaying: false, currentSong: songs.isNotEmpty ? songs[0] : null));
    } else {
      emit(LibraryError(message: 'Nenhuma música encontrada'));
    }
  }

  void setCurrentSound(SongModel? songModel) {
    pauseSound();
    emit(LibrarySuccess(songs: state.songs, currentSong: songModel, isPlaying: false));
    playSound();
  }

  void playSound() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      await player.setFilePath(state.currentSong!.absolutePath);
      await player.play();
      emit(LibrarySuccess(
        songs: state.songs,
        currentSong: state.currentSong,
        isPlaying: true,
      ));
    } catch (e) {
      emit(LibraryError(
        songs: state.songs,
        currentSong: state.currentSong,
        isPlaying: false,
        message: e.toString(),
      ));
    }
  }

  void pauseSound() async {
    try {
      await player.pause();
      emit(LibrarySuccess(
        songs: state.songs,
        currentSong: state.currentSong,
        isPlaying: false,
      ));
    } catch (e) {
      emit(LibraryError(message: e.toString()));
    }
  }

  void nextSound() {
    if (state.songs!.indexOf(state.currentSong!) < state.songs!.length - 1) {
      pauseSound();
      setCurrentSound(state.songs![state.songs!.indexOf(state.currentSong!) + 1]);
      playSound();
    } else {
      pauseSound();
      setCurrentSound(state.songs![0]);
      playSound();
    }
  }

  void previousSound() {
    if (state.songs!.indexOf(state.currentSong!) > 0) {
      setCurrentSound(state.songs![state.songs!.indexOf(state.currentSong!) - 1]);
    }
  }

  void deleteSound(SongModel songModel, BuildContext context) async {
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
      emit(LibrarySuccess(songs: list, currentSong: state.currentSong, isPlaying: false));
    }
  }

  void clearData() {
    emit(LibraryLoading());
    local.clearData();
    emit(LibraryError(message: 'Nenhuma música encontrada'));
  }
}
