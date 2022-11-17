import 'dart:ui';

import 'package:uuid/uuid.dart';

class Music {
  String id = const Uuid().v4();
  String name;
  String? artist;
  String url;
  bool isLocal;
  Image? cover;
  Duration? length;

  Music(
      {required this.name,
      required this.url,
      this.isLocal = true,
      this.cover,
      this.length,
      this.artist});
}
