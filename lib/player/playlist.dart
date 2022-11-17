import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_player/common/music.dart';

enum PlayListEventType { add, next, pre, tap }

class PlayListEvent {
  PlayListEventType type;
  Music? music;

  PlayListEvent({required this.type, this.music});
}

class PlayList {
  int _curPlayIndex = -1;
  List<Music> musics = [];

  StreamController<PlayListEvent> streamController =
      StreamController.broadcast();

  add(Music music) {
    musics.add(music);
    _curPlayIndex = musics.length - 1;
    streamController.add(PlayListEvent(type: PlayListEventType.add));
    streamController.add(PlayListEvent(type: PlayListEventType.tap, music: musics[_curPlayIndex]));
  }
  addAll(List<Music> music) {
    musics.addAll(music);
    _curPlayIndex = musics.length - 1;
    streamController.add(PlayListEvent(type: PlayListEventType.add));
    streamController.add(PlayListEvent(type: PlayListEventType.tap, music: musics[_curPlayIndex]));
  }
  Music? get next {
    if (musics.isEmpty) {
      return null;
    }
    _curPlayIndex = (_curPlayIndex + 1) % musics.length;
    streamController.add(PlayListEvent(type: PlayListEventType.next));
    return musics[_curPlayIndex];
  }
  Music? get pre {
    if (musics.isEmpty) {
      return null;
    }
    _curPlayIndex = (_curPlayIndex - 1 + musics.length) % musics.length;
    streamController.add(PlayListEvent(type: PlayListEventType.pre));
    return musics[_curPlayIndex];
  }

  dispose() {
    streamController.close();
  }
}

class PlayListWidget extends StatefulWidget {
  final PlayList playList;

  const PlayListWidget({Key? key, required this.playList}) : super(key: key);

  @override
  State<PlayListWidget> createState() => _PlayListWidgetState();
}

class _PlayListWidgetState extends State<PlayListWidget> {
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.playList.streamController.stream.listen((event) {
      if (event.type == PlayListEventType.add ||
          event.type == PlayListEventType.next ||
      event.type == PlayListEventType.pre) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("播放列表"),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close))
          ],
        ),
        Expanded(
            child: ListView.builder(
                itemCount: widget.playList.musics.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(widget.playList.musics[index].name),
                    tileColor: index == widget.playList._curPlayIndex
                        ? Colors.grey
                        : null,
                    onTap: () {
                      setState(() {
                        widget.playList._curPlayIndex = index;
                      });
                      widget.playList.streamController.add(PlayListEvent(type: PlayListEventType.tap, music: widget.playList.musics[index]));
                    },
                  );
                }))
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }
}
