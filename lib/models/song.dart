import 'dart:typed_data';

class Song {
  final String title;
  final String artist;
  final String album;
  final Uint8List? cover;
  final String path;

  Song({
    required this.title,
    required this.artist,
    required this.album,
    this.cover,
    required this.path,
  });
}
