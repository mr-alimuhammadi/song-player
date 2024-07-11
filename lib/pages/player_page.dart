import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/song.dart';

class PlayerPage extends StatefulWidget {
  final List<Song> songs;
  final int currentIndex;
  final ValueChanged<int> setCurrentIndex;
  final int inPlayerSongIndex;
  final ValueChanged<int> setInPlayerSongIndex;
  final bool isPlaying;
  final ValueChanged<bool> setIsPlaying;
  final AudioPlayer player;

  const PlayerPage(
      {super.key,
      required this.currentIndex,
      required this.songs,
      required this.setCurrentIndex,
      required this.inPlayerSongIndex,
      required this.setInPlayerSongIndex,
      required this.isPlaying,
      required this.setIsPlaying,
      required this.player});

  @override
  PlayerPageState createState() => PlayerPageState();
}

class PlayerPageState extends State<PlayerPage> {
  int currentIndex = 0;
  void setCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
      widget.setCurrentIndex(index);
    });
  }

  int inPlayerSongIndex = 0;
  void setInPlayerSongIndex(int index) {
    setState(() {
      inPlayerSongIndex = index;
      widget.setInPlayerSongIndex(index);
    });
  }

  bool isPlaying = false;
  void setIsPlaying(bool playing) {
    setState(() {
      isPlaying = playing;
      widget.setIsPlaying(playing);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      currentIndex = widget.currentIndex;
      inPlayerSongIndex = widget.inPlayerSongIndex;
      isPlaying = widget.isPlaying;
    });
  }

  void playSong() {
    if (inPlayerSongIndex == currentIndex) {
      widget.player.play();
    } else {
      widget.player
          .setUrl(widget.songs[currentIndex].path)
          .then((_) => {widget.player.play()});
      setInPlayerSongIndex(currentIndex);
    }
    setIsPlaying(true);
  }

  void playNext() {
    setCurrentIndex((currentIndex + 1) % widget.songs.length);
    playSong();
  }

  void playPrevious() {
    setCurrentIndex(
        currentIndex == 0 ? widget.songs.length - 1 : currentIndex - 1);
    playSong();
  }

  void pauseSong() {
    widget.player.pause();
    setIsPlaying(false);
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.songs[currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          song.cover != null
              ? Image.memory(song.cover!)
              : const Icon(Icons.music_note),
          const SizedBox(height: 20),
          Text(song.title, style: const TextStyle(fontSize: 24)),
          Text(song.artist, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: playPrevious,
              ),
              isPlaying && inPlayerSongIndex == currentIndex
                  ? IconButton(
                      icon: const Icon(Icons.pause),
                      onPressed: pauseSong,
                    )
                  : IconButton(
                      icon: const Icon(Icons.play_arrow), onPressed: playSong),
              IconButton(
                  icon: const Icon(Icons.skip_next), onPressed: playNext),
            ],
          ),
        ],
      ),
    );
  }
}
