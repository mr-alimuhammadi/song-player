import 'dart:io';
import 'dart:typed_data';

import 'package:audiotagger/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:song_player/pages/player_page.dart';

import '../models/song.dart';

class PlaylistPage extends StatefulWidget {
  final String folderPath;

  const PlaylistPage({super.key, required this.folderPath});

  @override
  PlaylistPageState createState() => PlaylistPageState();
}

class PlaylistPageState extends State<PlaylistPage> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final Audiotagger _tagger = Audiotagger();

  bool isPlayerPageOpen = false;
  void setIsPlayerPageOpen(bool open) {
    setState(() {
      isPlayerPageOpen = open;
    });
  }

  List<Song> songs = [];
  int currentIndex = 0;
  void setCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  int inPlayerSongIndex = -1;
  void setInPlayerSongIndex(int index) {
    setState(() {
      inPlayerSongIndex = index;
    });
  }

  bool isPlaying = false;
  void setIsPlaying(bool playing) {
    setState(() {
      isPlaying = playing;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSongs();
    if (!isPlayerPageOpen) {
      audioPlayer.processingStateStream.listen((state) {
        if (state == ProcessingState.completed) {
          setCurrentIndex((currentIndex + 1) % songs.length);
          playSong();
        }
      });
    }
  }

  Future<void> fetchSongs() async {
    if (await Permission.storage.request().isGranted) {
      final folder = Directory(widget.folderPath);
      if (await folder.exists()) {
        final files = folder
            .listSync()
            .whereType<File>()
            .map((file) => file.path)
            .toList();

        for (var filePath in files) {
          try {
            final Tag? tag = await _tagger.readTags(path: filePath);
            Uint8List? cover = await _tagger.readArtwork(path: filePath);

            setState(() {
              songs.add(Song(
                title: tag?.title ?? filePath.split('/').last,
                artist: tag?.artist ?? 'Unknown Artist',
                album: tag?.album ?? 'Unknown Album',
                cover: cover,
                path: filePath,
              ));
            });
          } catch (e) {
            print("Error reading tags for file $filePath: $e");
          }
        }
      } else {
        print("Directory does not exist");
      }
    } else {
      print('Permission denied');
    }
  }

  void playSong() {
    if (inPlayerSongIndex == currentIndex) {
      audioPlayer.play();
    } else {
      audioPlayer
          .setUrl(songs[currentIndex].path)
          .then((_) => {audioPlayer.play()});
      setInPlayerSongIndex(currentIndex);
    }
    setIsPlaying(true);
  }

  void pauseSong() {
    audioPlayer.pause();
    setIsPlaying(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlist'),
      ),
      body: songs.isEmpty
          ? const Center(child: Text('No songs found in the selected folder.'))
          : ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  leading: song.cover != null
                      ? Image.memory(song.cover!)
                      : const Icon(Icons.music_note),
                  title: Text(song.title),
                  subtitle: Text(song.artist),
                  trailing: IconButton(
                    icon: isPlaying && currentIndex == index
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow),
                    onPressed: () {
                      setState(() {
                        currentIndex = index;
                        isPlayerPageOpen = true;
                      });
                      if (isPlaying && currentIndex == index) {
                        pauseSong();
                      } else {
                        playSong();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayerPage(
                              songs: songs,
                              currentIndex: currentIndex,
                              setCurrentIndex: setCurrentIndex,
                              inPlayerSongIndex: inPlayerSongIndex,
                              setInPlayerSongIndex: setInPlayerSongIndex,
                              isPlaying: isPlaying,
                              setIsPlaying: setIsPlaying,
                              player: audioPlayer,
                              setIsPlayerPageOpen: setIsPlayerPageOpen,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
