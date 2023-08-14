import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simple_player/pojo/music.dart';
import 'package:simple_player/service/platform_api.dart';

class KuwoApi extends PlatFormApi {
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
    http.Response res = await http.get(Uri.parse("http://search.kuwo.cn/r.s?client=kt&all=$keyWord&pn=$pageIndex&rn=$pageSize&uid=794762570&ver=kwplayer_ar_9.2.2.1&vipver=1&show_copyright_off=1&newver=1&ft=music&cluster=0&strategy=2012&encoding=utf8&rformat=json&vermerge=1&mobi=1&issubtitle=1"));

    if (res.statusCode == 200) {
      List<dynamic> list = jsonDecode(res.body.replaceAll("'", "\""))['abslist'] as List<dynamic>;

      List<MusicInfo> mapResult = [];
      for (var value in list) {
        Map<String, dynamic> cur = value as Map<String, dynamic>;
        mapResult.add(MusicInfo(hash: cur['MUSICRID'], name: cur['SONGNAME'], artist: cur['ARTIST']));
      }
      return mapResult;
    } else {
      return [];
    }
  }
}