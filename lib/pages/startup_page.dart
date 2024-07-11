import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:song_player/pages/playlist_page.dart';
import 'package:permission_handler/permission_handler.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Song Player!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (await _requestPermission()) {
                  String? folderPath =
                      await FilePicker.platform.getDirectoryPath();
                  if (folderPath != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PlaylistPage(folderPath: folderPath),
                      ),
                    );
                  } else {
                    print("No folder selected");
                  }
                }
              },
              child: const Text('Choose Folder'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _requestPermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      print("Permission granted");
      return true;
    } else {
      print("Permission denied");
      openAppSettings();
      return false;
    }
  }
}
