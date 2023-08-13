import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_player/pojo/music.dart';

class PlayListWidget extends StatefulWidget {
  /// 列表项点击事件
  final void Function(Music) onItemTap;
  const PlayListWidget({super.key, required this.onItemTap});

  @override
  State<PlayListWidget> createState() => PlayListWidgetState();
}

class PlayListWidgetState extends State<PlayListWidget> {
  int _curPlayIndex = -1;
  final List<Music> _musics = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("PlayList"),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close))
          ],
        ),
        Expanded(
            child: ListView.builder(
                itemCount: _musics.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_musics[index].name),
                    tileColor: index == _curPlayIndex ? Colors.grey : null,
                    onTap: () {
                      widget.onItemTap(_musics[index]);
                      setState(() {
                        _curPlayIndex = index;
                      });
                    },
                  );
                }))
      ],
    );
  }

  add(Music music) {
    _musics.add(music);
    _curPlayIndex = _musics.length - 1;
    setState(() {});
  }

  addAll(List<Music> music) {
    _musics.addAll(music);
    _curPlayIndex = _musics.length - 1;
    setState(() {});
  }

  Music? get next {
    if (_musics.isEmpty) {
      return null;
    }
    _curPlayIndex = (_curPlayIndex + 1) % _musics.length;
    setState(() {});
    return _musics[_curPlayIndex];
  }

  Music? get pre {
    if (_musics.isEmpty) {
      return null;
    }
    _curPlayIndex = (_curPlayIndex - 1 + _musics.length) % _musics.length;
    setState(() {});
    return _musics[_curPlayIndex];
  }
}
