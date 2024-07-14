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
  final ValueChanged<bool> setIsPlayerPageOpen;

  const PlayerPage(
      {super.key,
      required this.currentIndex,
      required this.songs,
      required this.setCurrentIndex,
      required this.inPlayerSongIndex,
      required this.setInPlayerSongIndex,
      required this.isPlaying,
      required this.setIsPlaying,
      required this.player,
      required this.setIsPlayerPageOpen});

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
    // Listen to the processing state stream
    widget.player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        playNext();
      }
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

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    super.dispose();
    widget.setIsPlayerPageOpen(false);
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.songs[currentIndex];
    return Scaffold(
      backgroundColor: const Color(0xFF130f1d),
      appBar: AppBar(
        backgroundColor: const Color(0xFF130f1d),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Transform.rotate(
              angle: -3.14 / 2,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              )),
        ),
        title: Container(
          decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.white, width: 1),
                  bottom: BorderSide(color: Colors.white, width: 1))),
          child: const Text(
            'SONG PLAYER',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: song.cover != null
                      ? Image.memory(
                          song.cover!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset("assets/images/default_cover.png"),
                )),
          ),
          const SizedBox(height: 40),
          Text(song.title,
              style: const TextStyle(fontSize: 24, color: Colors.white)),
          Text(song.artist,
              style: const TextStyle(fontSize: 18, color: Colors.white)),
          const SizedBox(height: 30),
          StreamBuilder<Duration>(
            stream: widget.player.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = widget.player.duration ?? Duration.zero;
              return Column(
                children: [
                  Slider(
                    activeColor: Colors.deepPurpleAccent,
                    inactiveColor: Colors.grey,
                    min: 0.0,
                    max: duration.inMilliseconds.toDouble(),
                    value: position.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      widget.player.seek(Duration(milliseconds: value.toInt()));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatDuration(position),
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          formatDuration(duration),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const IconButton(
              icon: Icon(
                Icons.shuffle_outlined,
                size: 35,
                color: Colors.grey,
              ),
              onPressed: null,
            ),
            IconButton(
              icon: const Icon(
                Icons.skip_previous,
                size: 50,
                color: Colors.white,
              ),
              onPressed: playPrevious,
            ),
            isPlaying && inPlayerSongIndex == currentIndex
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Container(
                      color: Colors.deepPurpleAccent,
                      child: IconButton(
                        icon: const Icon(Icons.pause,
                            size: 50, color: Colors.white),
                        onPressed: pauseSong,
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Container(
                      color: Colors.deepPurpleAccent,
                      child: IconButton(
                        icon: const Icon(
                          Icons.play_arrow,
                          size: 50,
                          color: Colors.white,
                        ),
                        onPressed: playSong,
                      ),
                    ),
                  ),
            IconButton(
              icon: const Icon(
                Icons.skip_next,
                size: 50,
                color: Colors.white,
              ),
              onPressed: playNext,
            ),
            const IconButton(
              icon: Icon(
                Icons.repeat_one_outlined,
                size: 35,
                color: Colors.grey,
              ),
              onPressed: null,
            ),
          ]),
        ],
      ),
    );
  }
}
