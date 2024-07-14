# Song Player

A Flutter application for playing songs from a selected folder. This project allows users to choose a folder containing music files and play them using the just_audio package.

## Usage
#### step-by-step guide:

1. Open your terminal or command prompt.
2. Clone the song player repository by running the following command:
```sh
git clone https://github.com/mr-alimuhammadi/song-player.git
```
This will download the repository to your local machine.

3. Change into the cloned directory:
```sh
cd song-player
```
4. Run the following command to install the project's dependencies:
```sh
flutter pub get
```
This will download and install all the dependencies specified in the `pubspec.yaml` file.

That's it! You should now have a local copy of the song player project with all its dependencies installed. You can now run the project using `flutter run` or `flutter debug` commands.

Note: Make sure you have Flutter installed on your machine and have set up your environment correctly before running these commands.

## Dependencies

### General Dependencies

- **flutter**: The Flutter framework itself.
- **file_picker**: ^5.2.2 - A package for file picking functionality.
- **audiotagger**: ^2.2.1 - A package for reading and writing audio metadata.
- **just_audio**: ^0.9.18 - A feature-rich audio player for Flutter.
- **provider**: ^6.0.1 - A wrapper around InheritedWidget to make state management easier.
- **permission_handler**: ^11.1.0 - A package to handle permissions for iOS and Android.

Note: the **permission_handler** compatible up to Android 12

### Additional Dependencies

- **cupertino_icons**: ^1.0.6 - The Cupertino Icons font for iOS style icons.

### Development Dependencies

- **flutter_test**: The Flutter testing framework.
- **flutter_lints**: ^3.0.0 - A package containing a set of recommended lints to encourage good coding practices.

## Environment

- **Dart SDK**: '>=3.4.0 <4.0.0'

## Versioning

- **Current Version**: 1.0.0+1

## Assets

The following assets are included in the project:

- `assets/images/airpods.png`
- `assets/images/default_cover.png`


## Documentation

### models Folder
The models folder contains all the data models used within the Flutter application. These models represent the structure of the data that the application works with. This folder is essential for maintaining a clean architecture by separating data representations from business logic and UI.

##### Purpose
The main purpose of the `models` folder is to:
1. Define the structure of data objects.
2. Handle data serialization and deserialization.
3. Ensure type safety within the application.

##### Typical Contents
The `models` folder typically contains:
- Dart classes representing different data entities.
- Utility methods for data manipulation and validation.

### Song Model

The `Song` class is a data model that represents a song in the Flutter application. This class is used to define the structure of a song object, including its title, artist, album, cover art, and file path.

##### Purpose
The `Song` class is designed to:
1. Provide a structured way to represent song data.
2. Facilitate the handling of song metadata within the application.
3. Ensure type safety for song-related data.

### pages Folder
The pages folder contains the primary screens of the application. Each screen is responsible for a specific part of the app's functionality

### StartupPage

The `StartupPage` is the main entry point of the Song Player application. It displays a welcome message and a button to select a folder to load music files.

##### Design

The `StartupPage` is a stateless widget that consists of:
* An `AppBar` with a title of "Song Player"
* A `Column` widget containing a welcome message and a button
* The button is an `ElevatedButton` with the text "Choose Folder"

##### Functionality

When the "Choose Folder" button is pressed, the `StartupPage` performs the following actions:
1. Requests storage permission using the `PermissionHandler` package
2. If permission is granted, it uses the `FilePicker` package to select a folder
3. If a folder is selected, it navigates to the `PlaylistPage` widget, passing the selected folder path as an argument
4. If permission is denied or no folder is selected, it prints an error message

##### Methods

* `_requestPermission()`: Requests storage permission and returns a boolean indicating whether permission was granted or not.

##### Notes

* The `PlaylistPage` widget is not included in this document, but it is responsible for displaying a list of music files in the selected folder and allowing users to play them.
* The `FilePicker` package is used to select a folder, and the `PermissionHandler` package is used to request storage permission.
* The `openAppSettings()` function is called if permission is denied, which opens the app settings screen to allow users to grant permission.

### PlaylistPage

The `PlaylistPage` is a stateful widget that displays a list of songs in a selected folder and allows users to play them. It uses the `AudioPlayer` and `Audiotagger` packages to manage the playback of audio files.

##### Design

The `PlaylistPage` consists of:
* A `Scaffold` with an `AppBar` displaying the title "Playlist"
* A `ListView` displaying the list of songs
* Each song is represented by a `ListTile` with a leading image (album art), title, subtitle (artist), and trailing icon (play/pause button)

##### Functionality

When the `PlaylistPage` is created:
1. It fetches the list of songs from the selected folder using the `fetchSongs()` method
2. It initializes the playback state with an empty list of songs and sets up event listeners for playback state changes
3. When a song is tapped, it opens the `PlayerPage` with the selected song

##### Methods

* `fetchSongs()`: Fetches the list of songs from the selected folder
* `playSong()`: Plays or pauses the current song
* `pauseSong()`: Pauses the current song
* `openPlayerPage(int index)`: Opens the `PlayerPage` with the selected song

##### Properties

* `songs`: The list of songs fetched from the selected folder
* `currentIndex`: The current index of the song being played
* `inPlayerSongIndex`: The index of the song being played in the player page
* `isPlaying`: Whether playback is currently playing or paused
* `setIsPlaying(bool playing)`: Updates the playback state

##### Initialization

In the `initState()` method, it sets up event listeners for playback state changes and initializes the playback state.

##### Error Handling

If an error occurs while fetching songs or reading tags, it prints an error message.

##### Notes

* This widget uses the `AudioPlayer` and `Audiotagger` packages to manage playback and tagging of audio files.
* The `PlayerPage` widget is not included in this documentation, but it is responsible for displaying playback controls and managing playback state.
* The playlist is stored in memory and is not persisted across app restarts.

### PlayerPage

The `PlayerPage` is a stateful widget that displays the currently playing song and provides playback controls. It is used to control the playback of audio files.

##### Design

The `PlayerPage` consists of:
* An `AppBar` with the title "Now Playing"
* A `Column` containing the album art, song title, artist, and playback controls
* A `Slider` for seeking through the song
* Playback controls (play/pause, previous, next)

##### Functionality

When the `PlayerPage` is created:
1. It initializes the playback state with the current song and playback position
2. It sets up event listeners for playback state changes (e.g. play/pause, seek)
3. It updates the playback state when the user interacts with the playback controls

##### Methods

* `playSong()`: Plays or pauses the current song
* `playNext()`: Plays the next song in the playlist
* `playPrevious()`: Plays the previous song in the playlist
* `pauseSong()`: Pauses the current song
* `formatDuration(Duration duration)`: Formats the duration of a song

##### Properties

* `currentIndex`: The current index of the song being played
* `inPlayerSongIndex`: The index of the song being played in the player page
* `isPlaying`: Whether playback is currently playing or paused
* `player`: The audio player object
* `setIsPlayerPageOpen`: A callback to set whether the player page is open

##### Initialization

In the `initState()` method, it sets up event listeners for playback state changes and initializes the playback state.

##### Error Handling

If an error occurs while playing a song, it will be handled by the audio player.

##### Notes

* This widget uses the `AudioPlayer` package to manage playback.
* The playback state is stored in memory and is not persisted across app restarts.
* The playlist is stored in memory and is not persisted across app restarts.

This documentation assumes that you have basic knowledge of Flutter and Dart programming. If you're new to these technologies, you may want to start with some online tutorials or documentation before diving into this codebase.
