import '../pojo/music.dart';

class MusicInfo {
  String hash;
  String name;
  String? artist;
  MusicInfo({required this.hash, required this.name, this.artist});
}

abstract class PlatFormApi {
  Future<List<MusicInfo>> search(String keyWord, int pageIndex, int pageSize) {
    throw UnimplementedError();
  }
  Future<Music?> getDetail(MusicInfo info) {
    throw UnimplementedError();
  }
}