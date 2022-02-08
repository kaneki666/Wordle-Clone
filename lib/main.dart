import 'package:flutter/material.dart';
import 'package:wordle/screens/game/game.dart';
import 'package:wordle/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle',
      theme: WordleTheme.darkTheme(),
      debugShowCheckedModeBanner: false,
      home: const GameScreen(),
    );
  }
}
