import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

part 'library_state.dart';

class LibraryBloc extends Cubit<LibraryState> {
  LibraryBloc() : super(LibraryInitial());

  final player = AudioPlayer();

  void getSounds(BuildContext context) async {
    emit(LibraryLoading());
    final manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final songs = manifestMap.keys.where((String key) => key.contains('assets/audio/')).toList();
    emit(LibrarySuccess(songs));
  }

  void playSound(String path) async {
    try {
      await player.setAsset(path);
      player.play();
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }
}
