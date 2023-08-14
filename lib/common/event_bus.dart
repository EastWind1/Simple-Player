import 'dart:async';

import 'package:simple_player/pojo/music.dart';

class EventBus {
  EventBus._internal();

  factory EventBus() => _instance;

  static final EventBus _instance = EventBus._internal();

  final StreamController<Music> addAndPlay = StreamController();
}
