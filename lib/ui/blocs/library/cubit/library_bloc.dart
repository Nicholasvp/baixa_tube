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

  final ValueNotifier<int> currentPosition = ValueNotifier(0);

  void getSounds() async {
    emit(LibraryLoading());
    final result = await local.getData(LocalDataKey.songs.name);
    if (result != null) {
      final songs = result.map((e) => SongModel.fromJson(e)).toList();
      emit(LibrarySuccess(songs: songs, isPlaying: player.playing, currentSong: songs.isNotEmpty ? songs[0] : null));
    } else {
      emit(LibraryError(message: 'Nenhuma música encontrada'));
    }
  }

  void setCurrentSound(SongModel? songModel) async {
    pauseSound();
    emit(LibrarySuccess(songs: state.songs, currentSong: songModel, isPlaying: player.playing));
    await Future.delayed(const Duration(milliseconds: 100));
    await player.setFilePath(state.currentSong!.absolutePath);

    playSound();
  }

  void playSound() async {
    try {
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
        isPlaying: player.playing,
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
    } else {
      pauseSound();
      setCurrentSound(state.songs![0]);
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
      emit(LibrarySuccess(songs: list, currentSong: state.currentSong, isPlaying: player.playing));
    }
  }

  void clearData() {
    emit(LibraryLoading());
    local.clearData();
    emit(LibraryError(message: 'Nenhuma música encontrada'));
  }

  Future<void> openFolder(String path) async {
    try {
      // Converte para um caminho absoluto, garantindo compatibilidade
      String folderPath = File(path).parent.absolute.path.replaceAll('/', '\\');

      if (!await Directory(folderPath).exists()) {
        throw 'Pasta não encontrada: $folderPath';
      }
      print('Tentando abrir pasta: $folderPath');

      if (Platform.isWindows) {
        await Process.run('explorer', [folderPath]);
      } else if (Platform.isMacOS) {
        await Process.run('open', [folderPath]);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [folderPath]);
      } else {
        throw 'Abertura de pastas não suportada nesta plataforma';
      }
    } catch (e) {
      print('Erro ao tentar abrir a pasta: $e');
    }
  }

  void seekSound(Duration duration) {
    player.seek(duration);
    emit(LibrarySuccess(
      songs: state.songs,
      currentSong: state.currentSong,
      isPlaying: state.isPlaying,
    ));
  }
}
