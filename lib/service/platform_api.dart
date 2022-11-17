import '../common/music.dart';

class MusicInfo {
  String key;
  String name;
  String? artist;
  MusicInfo({required this.key, required this.name, this.artist});
}

abstract class PlatFormApi {
  Future<List<MusicInfo>> search(String keyWord, int pageIndex, int pageSize);
  Future<Music?> getDetail(MusicInfo info);
}