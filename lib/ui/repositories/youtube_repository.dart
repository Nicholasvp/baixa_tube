import 'dart:io';

import 'package:baixa_tube/core/enums/enums.dart';
import 'package:baixa_tube/ui/models/song_model.dart';
import 'package:baixa_tube/ui/repositories/local_repository.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeRepository {
  final yt = YoutubeExplode();
  final local = LocalRepository();

  Future<Video> getVideo(String url) async {
    var video = await yt.videos.get(url);
    return video;
  }

  Future<String> downloadAudio(String url) async {
    var video = await yt.videos.get(url);
    var manifest = await yt.videos.streams.getManifest(url);
    var streamInfo = manifest.audioOnly.withHighestBitrate();
    var stream = yt.videos.streamsClient.get(streamInfo);

    var title = video.title.replaceAll(RegExp(r'[^\w\s]'), '').replaceAll(' ', '_');
    var fileName = 'assets/audio/$title.mp3';
    var file = File(fileName);
    var fileStream = file.openWrite();

    SongModel songModel = SongModel(title: video.title, url: video.url, path: fileName, thumb: video.thumbnails.highResUrl);

    List<String> reponse = await local.getData(LocalDataKey.songs.name) ?? [];
    reponse.add(songModel.toJson());

    await local.saveData(
      LocalDataKey.songs.name,
      reponse,
    );

    await stream.pipe(fileStream);
    await fileStream.flush();
    await fileStream.close();

    return fileName;
  }
}
