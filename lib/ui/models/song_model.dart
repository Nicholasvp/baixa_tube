// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SongModel {
  final String title;
  final String url;
  final String path;
  final String thumb;
  SongModel({
    required this.title,
    required this.url,
    required this.path,
    required this.thumb,
  });

  SongModel copyWith({
    String? title,
    String? url,
    String? path,
    String? thumb,
  }) {
    return SongModel(
      title: title ?? this.title,
      url: url ?? this.url,
      path: path ?? this.path,
      thumb: thumb ?? this.thumb,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'url': url,
      'path': path,
      'thumb': thumb,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      title: map['title'] as String,
      url: map['url'] as String,
      path: map['path'] as String,
      thumb: map['thumb'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) => SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(title: $title, url: $url, path: $path, thumb: $thumb)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;

    return other.title == title && other.url == url && other.path == path && other.thumb == thumb;
  }

  @override
  int get hashCode {
    return title.hashCode ^ url.hashCode ^ path.hashCode ^ thumb.hashCode;
  }
}
