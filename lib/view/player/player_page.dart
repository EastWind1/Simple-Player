import 'package:flutter/cupertino.dart';
import 'package:simple_player/pojo/music.dart';
import 'package:simple_player/view/player/player.dart';
import 'package:simple_player/view/player/playlist.dart';

class PlayerPage extends StatelessWidget  {
  PlayerPage({super.key});
  final GlobalKey<PlayerWidgetState> playerKey = GlobalKey();
  final GlobalKey<PlayListWidgetState> playListKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      PlayListWidget(key: playListKey, onItemTap: playListTap),
      PlayerWidget(key: playerKey, playListKey: playListKey)
    ]);
  }

  // 播放列表点击回调
  playListTap(Music music) {
    playerKey.currentState?.play(music);
  }
}
