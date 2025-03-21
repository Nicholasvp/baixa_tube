import 'dart:io';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeDownload {
  final yt = YoutubeExplode();

  Future<Video> getVideo(String url) async {
    var video = await yt.videos.get(url);
    return video;
  }

  downloadAudio(String url) async {
    var yt = YoutubeExplode();
    var video = await yt.videos.get(url);
    var manifest = await yt.videos.streams.getManifest(url);
    var streamInfo = manifest.audioOnly.withHighestBitrate();
    var stream = yt.videos.streamsClient.get(streamInfo);

    var file = File('audio.mp3');
    var fileStream = file.openWrite();

    await stream.pipe(fileStream);
    await fileStream.flush();
    await fileStream.close();
  }
}
