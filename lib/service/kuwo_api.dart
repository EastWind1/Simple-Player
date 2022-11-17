import 'dart:convert';
import 'package:simple_player/common/music.dart';
import 'package:simple_player/service/platform_api.dart';
import 'package:http/http.dart' as http;

class KuwoApi extends PlatFormApi {
  @override
  Future<Music?> getDetail(MusicInfo info) async {
    http.Response res = await http.get(Uri.parse("http://antiserver.kuwo.cn/anti.s?type=convert_url&rid=${info.key}&format=mp3&response=url"));
    if (res.statusCode == 200) {
      return Music(name: info.name, artist: info.artist, url: res.body, isLocal: false);
    } else {
      return null;
    }
  }

  @override
  Future<List<MusicInfo>> search(String keyWord, int pageIndex, int pageSize) async {
    http.Response res = await http.get(Uri.parse("http://search.kuwo.cn/r.s?all=$keyWord&ft=music& itemset=web_2013&client=kt&pn=$pageIndex&rn=$pageSize&rformat=json&encoding=utf8"));

    if (res.statusCode == 200) {
      List<dynamic> list = jsonDecode(res.body.replaceAll("'", "\""))['abslist'] as List<dynamic>;

      List<MusicInfo> mapResult = [];
      for (var value in list) {
        Map<String, dynamic> cur = value as Map<String, dynamic>;
        mapResult.add(MusicInfo(key: cur['MUSICRID'], name: cur['SONGNAME'], artist: cur['ARTIST']));
      }
      return mapResult;
    } else {
      return [];
    }
  }
}