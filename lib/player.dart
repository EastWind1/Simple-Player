import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final player = AudioPlayer();

  /// 标题
  String title = "";

  /// 是否正在播放
  bool isPlaying = false;

  _PlayerState() {
    initEventListener();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: Colors.grey,
          alignment: Alignment.center,
          child: Column(children: [
            /// 标题区
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(title)],
            ),

            /// 播放器控制区
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              /// 左侧
               Expanded(
                flex: 2,
                child: Container(),
              ),

              /// 中间
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.skip_previous),
                          onPressed: () {}),
                      IconButton(
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: playButtonClick,
                      ),
                      IconButton(
                          icon: const Icon(Icons.skip_next), onPressed: () {}),
                    ]
                  )),

              /// 右侧
              Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: selectFile,
                          icon: const Icon(Icons.file_open))
                    ],
                  )),
            ]),
          ]),
        ));
  }

  /// 播放按钮点击
  playButtonClick() {
    if (isPlaying) {
      player.pause();
    } else {
      player.resume();
    }
  }

  /// 选择本地文件并播放
  selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      PlatformFile file = result.files.single;
      play(file.name, file.path!);
    }
  }

  /// 根据url播放文件
  /// [url] 路径url
  play(String title, String url) async {
    await player.play(DeviceFileSource(url));
    setState(() {
      this.title = title;
    });
  }

  ///播放器事件监听初始化
  initEventListener() {
    // 播放器状态改变
    player.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });
    // 当前歌曲播放完成
    player.onPlayerComplete.listen((event) {
      player.resume();
    });
  }
}
