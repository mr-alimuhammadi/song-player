import 'package:flutter/material.dart';
import 'package:song_player/pages/startup_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Song Player App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartupPage(),
    );
  }
}
