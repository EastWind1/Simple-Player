import 'dart:convert';
import 'package:simple_player/pojo/music.dart';
import 'package:simple_player/service/platform_api.dart';
import 'package:http/http.dart' as http;

class KugouApi extends PlatFormApi {
  @override
  Future<Music?> getDetail(MusicInfo info) async {
    http.Response res = await http.get(Uri.parse("http://antiserver.kuwo.cn/anti.s?type=convert_url&rid=${info.hash}&format=mp3&response=url"));
    if (res.statusCode == 200) {
      return Music(name: info.name, artist: info.artist, url: res.body, isLocal: false);
    } else {
      return null;
    }
  }

  @override
  Future<List<MusicInfo>> search(String keyWord, int pageIndex, int pageSize) async {
    http.Response res = await http.get(Uri.parse("http://mobilecdn.kugou.com/api/v3/search/song?format=json&keyword=$keyWord&page=$pageIndex&pagesize=$pageSize&showtype=1"));

    if (res.statusCode == 200) {
      List<dynamic> list = jsonDecode(res.body)['data']['info'] as List<dynamic>;

      List<MusicInfo> mapResult = [];
      for (var value in list) {
        Map<String, dynamic> cur = value as Map<String, dynamic>;
        mapResult.add(MusicInfo(hash: cur['hash'], name: cur['songname'], artist: cur['singername']));
      }
      return mapResult;
    } else {
      return [];
    }
  }
}