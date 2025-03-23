import 'dart:io';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeRepository {
  final yt = YoutubeExplode();

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

    await stream.pipe(fileStream);
    await fileStream.flush();
    await fileStream.close();

    return fileName;
  }
}
