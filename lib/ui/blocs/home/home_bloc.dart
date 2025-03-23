import 'package:baixa_tube/ui/repositories/youtube_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'home_state.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(HomeInitial());

  final youtubeRepository = YoutubeRepository();
  final urlController = TextEditingController();

  Future<void> download() async {
    emit(HomeLoading());
    try {
      String name = await youtubeRepository.downloadAudio(urlController.text);
      emit(HomeSuccess(name));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
