import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_player/pojo/music.dart';
import 'package:simple_player/view/player/playlist.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  // 播放器进度订阅
  late StreamSubscription _playerDurationSubscription;

  // 播放器状态订阅
  late StreamSubscription _playerStateSubscription;
  final GlobalKey<PlayListWidgetState> playListKey = GlobalKey();
  late AudioPlayer _player;

  /// 标题
  String title = "";

  /// 是否正在播放
  bool _isPlaying = false;

  /// 进度条进度
  double _position = 0;

  /// 进度条后方时间
  String _time = "--:--/--:--";

  /// 当前播放音乐
  Music? _curMusic;

  @override
  void initState() {
    super.initState();
    // 处理移动应用的音频上下文
    if (!kIsWeb) {
      const AudioContext audioContext = AudioContext(
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.ambient,
          options: [
            AVAudioSessionOptions.defaultToSpeaker,
            AVAudioSessionOptions.mixWithOthers,
          ],
        ),
        android: AudioContextAndroid(
          isSpeakerphoneOn: true,
          stayAwake: true,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.media,
          audioFocus: AndroidAudioFocus.gain,
        ),
      );
      AudioPlayer.global.setAudioContext(audioContext);
    }
    _player = AudioPlayer();
    _initEventListener();
  }

  /// 播放器事件监听初始化
  _initEventListener() {
    // 播放器状态改变
    _playerStateSubscription = _player.onPlayerStateChanged.listen((event) {
      setState(() {
        _isPlaying = event == PlayerState.playing;
      });
      // 播放完成
      if (event == PlayerState.completed) {
        play(playListKey.currentState?.next);
      }
    });
    // 进度改变
    _playerDurationSubscription = _player.onPositionChanged.listen((event) {
      if (_curMusic != null && _curMusic!.length != null) {
        String formatResult =
            "${_formatDuration(event)}/${_formatDuration(_curMusic!.length!)}";
        setState(() {
          // TODO: position位置异常，https://github.com/ryanheise/just_audio/issues/778
          _position =
              min(1, event.inMilliseconds / _curMusic!.length!.inMilliseconds);
          _time = formatResult;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      PlayListWidget(key: playListKey, onItemTap: playListTap),
      Container(
        color: Colors.white,
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
                  child: Slider(
                value: _position,
                onChangeStart: (value) {
                  if (_isPlaying) {
                    _player.pause();
                  }
                },
                onChanged: (value) {
                  Duration cur = _curMusic!.length! * value;
                  String formatResult =
                      "${_formatDuration(cur)}/${_formatDuration(_curMusic!.length!)}";
                  setState(() {
                    _position = value;
                    _time = formatResult;
                  });
                },
                onChangeEnd: (value) async {
                  if (_curMusic != null) {
                    Duration cur = value < 1
                        ? _curMusic!.length! * value
                        : _curMusic!.length!;
                    await _player.seek(cur);
                    _player.resume();
                  }
                },
              )),
              SizedBox(width: 100, child: Text(_time))
            ],
          ),

          /// 播放器控制区
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                      Expanded(
                          child: IconButton(
                              icon: const Icon(Icons.skip_previous),
                              onPressed: () {
                                play(playListKey.currentState?.pre);
                              })),
                      Expanded(
                          child: IconButton(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: _playButtonClick,
                      )),
                      Expanded(
                          child: IconButton(
                              icon: const Icon(Icons.skip_next),
                              onPressed: () {
                                play(playListKey.currentState?.next);
                              }))
                    ])),

            /// 右侧
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Web下不支持打开本地文件
                    kIsWeb
                        ? Container()
                        : IconButton(
                            onPressed: selectFileAndPlay,
                            icon: const Icon(Icons.file_open))
                  ],
                )),
          ]),
        ]),
      )
    ]);
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
  selectFileAndPlay() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['mp3', 'aac', 'ogg', 'mp4', 'wav', 'flac']);
    if (result != null && result.files.isNotEmpty) {
      List<Music> musics = result.files
          .map((file) => Music(name: file.name, url: file.path!, isLocal: true))
          .toList();
      playListKey.currentState?.addAll(musics);
      Music? next = playListKey.currentState?.next;
      if (next != null) {
        play(next);
      }
    }
  }

  /// 播放
  play(Music? music) async {
    if (music == null) {
      return;
    }
    _curMusic = music;
    await _player.pause();
    if (music.isLocal) {
      await _player.setSourceUrl(Uri.encodeFull("file://${music.url}"));
    } else {
      await _player.setSourceUrl(Uri.encodeFull(music.url!));
    }
    await _player.resume();
    Duration? duration = await _player.getDuration();
    if (music.length == null && duration != null) {
      music.length = duration;
    }
    setState(() {
      title = music.name;
    });
  }
  // 格式化时间显示
  String _formatDuration(Duration duration) {
    var microseconds = duration.inMicroseconds;
    var minutes = microseconds ~/ Duration.microsecondsPerMinute;
    microseconds = microseconds.remainder(Duration.microsecondsPerMinute);

    var minutesPadding = minutes < 10 ? "0" : "";

    var seconds = microseconds ~/ Duration.microsecondsPerSecond;

    var secondsPadding = seconds < 10 ? "0" : "";

    return "$minutesPadding$minutes:"
        "$secondsPadding$seconds";
  }
  // 播放列表点击
  playListTap(Music music) {
    play(music);
  }
  @override
  void dispose() {
    super.dispose();
    _player.dispose();
    _playerStateSubscription.cancel();
    _playerDurationSubscription.cancel();
  }
}
