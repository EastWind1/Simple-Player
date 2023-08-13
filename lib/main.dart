import 'package:flutter/material.dart';
import '../view/main_screen.dart';

void main() {
  runApp(const SimpleMusicPlayer());
}

class SimpleMusicPlayer extends StatelessWidget {
  const SimpleMusicPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Navigation());
  }
}

