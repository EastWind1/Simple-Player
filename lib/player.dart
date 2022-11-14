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
  final _player = AudioPlayer();

  /// 标题
  String title = "";

  /// 是否正在播放
  bool _isPlaying = false;

  /// 进度
  Duration _position = Duration.zero;

  /// 音频长度
  Duration _audioLength = Duration.zero;

  /// 时间长度
  String _time = "00:00/00:00";

  _PlayerState() {
    _initEventListener();
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

            /// 进度条
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 5,
                    child: Slider(
                      value: _position.inMilliseconds.toDouble(),
                      max: _audioLength.inMilliseconds.toDouble(),
                      onChangeStart: (value) {
                        if (_isPlaying) {
                          _player.pause();
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          _position = Duration(milliseconds: value.toInt());
                          _time = _calPlayTime();
                        });
                      },
                      onChangeEnd: (value) {
                        _player.seek(Duration(milliseconds: value.toInt()));
                        _player.resume();
                      },
                    )),
                Text(_time)
              ],
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
                          icon:
                              Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                          onPressed: _playButtonClick,
                        ),
                        IconButton(
                            icon: const Icon(Icons.skip_next),
                            onPressed: () {}),
                      ])),

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
  _playButtonClick() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.resume();
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
    await _player.play(DeviceFileSource(url));
    Duration? length = await _player.getDuration();
    setState(() {
      this.title = title;
      _audioLength = length!;
    });
  }

  ///播放器事件监听初始化
  _initEventListener() {
    // 播放器状态改变
    _player.onPlayerStateChanged.listen((event) {
      setState(() {
        _isPlaying = event == PlayerState.playing;
      });
    });
    // 当前歌曲播放完成
    _player.onPlayerComplete.listen((event) {
      _player.resume();
    });
    // 进度改变
    _player.onPositionChanged.listen((event) async {
      setState(() {
        _position = event;
        _time = _calPlayTime();
      });
    });
  }

  /// 计算播放时间字符串
  String _calPlayTime() {
    if (_audioLength == Duration.zero) {
      return "00:00/00:00";
    }
    String format(int source) {
      if (source < 10) {
        return "0$source";
      } else {
        return source.toString();
      }
    }

    return "${format(_position.inMinutes)}:${format(_position.inSeconds % 60)}/${format(_audioLength.inMinutes)}:${format(_audioLength.inSeconds % 60)}";
  }
}
