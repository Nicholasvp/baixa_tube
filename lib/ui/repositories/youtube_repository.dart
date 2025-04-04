import 'dart:io';

import 'package:baixa_tube/core/enums/enums.dart';
import 'package:baixa_tube/ui/models/song_model.dart';
import 'package:baixa_tube/ui/repositories/local_repository.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart';

class YoutubeRepository {
  final yt = YoutubeExplode();
  final local = LocalRepository();

  Future<Video> getVideo(String url) async {
    var video = await yt.videos.get(url);
    return video;
  }

  Future<String> getDownloadPath() async {
    Directory dir = await getApplicationSupportDirectory(); // Para Windows, melhor usar getApplicationSupportDirectory()
    String path = '${dir.path}/BaixaTube';

    // Criar diretório, se não existir
    Directory(path).createSync(recursive: true);

    return path;
  }

  Future<String> downloadAudio(String url) async {
    var video = await yt.videos.get(url);
    var manifest = await yt.videos.streams.getManifest(url);
    var streamInfo = manifest.audioOnly.withHighestBitrate();
    var stream = yt.videos.streamsClient.get(streamInfo);

    var title = video.title.replaceAll(RegExp(r'[^\w\s]'), '').replaceAll(' ', '_');
    var savePath = await getDownloadPath();
    var fileName = '$savePath/$title.mp3';
    var file = File(fileName);
    var fileStream = file.openWrite();

    SongModel songModel = SongModel(
      title: video.title,
      url: video.url,
      path: fileName,
      absolutePath: file.absolute.path,
      thumb: video.thumbnails.highResUrl,
      duration: video.duration,
    );

    List<String> reponse = await local.getData(LocalDataKey.songs.name) ?? [];
    if (!reponse.contains(songModel.toJson())) {
      reponse.add(songModel.toJson());
    }

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
