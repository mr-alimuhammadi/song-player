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
        toolbarHeight: 50,
        backgroundColor: Colors.black38,
        centerTitle: true,
        title: const Text(
          'SONG STORE',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black38,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: Image.asset("asstes/images/airpod.png"),
            ),
            const SizedBox(height: 20),
            const Text(
              'Getting Started',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10,
                shadowColor: Colors.blue,
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurpleAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
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
              child:
                  const Text('Choose Folder', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 10),
            const Text(
              'Mohammad mahdi Attai',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const Text(
              'Mohammad Ali Mohammadi',
              style: TextStyle(fontSize: 20, color: Colors.white),
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
