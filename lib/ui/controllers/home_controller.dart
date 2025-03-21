import 'package:baixa_tube/ui/repositories/youtube_download.dart';
import 'package:flutter/material.dart';

enum DownloadState { initial, loading, loaded, error }

class HomeController extends ChangeNotifier {
  final YoutubeDownload youtubeDownload = YoutubeDownload();
  final TextEditingController urlController = TextEditingController();

  DownloadState _state = DownloadState.initial;
  DownloadState get state => _state;

  void _setState(DownloadState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> download() async {
    _setState(DownloadState.loading);
    try {
      await youtubeDownload.downloadAudio(urlController.text);
      _setState(DownloadState.loaded);
    } catch (e) {
      _setState(DownloadState.error);
    }
  }
}
