import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_player/player/playlist.dart';
import 'package:simple_player/service/kuwo_api.dart';
import 'package:simple_player/service/platform_api.dart';

import '../common/music.dart';

class SearchResult extends StatefulWidget {
  final List<MusicInfo> _infos = [];
  final PlayList playList;
  late Function clear;
  late Function search;

  SearchResult({Key? key, required this.playList}) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  String curKeyword = '';
  int curIndex = 0;
  final pageSize = 20;

  @override
  void initState() {
    super.initState();
    widget.search = (String keyword) async {
      curIndex = 0;
      widget._infos.addAll(await KuwoApi().search(keyword, 0, pageSize));
      curKeyword = keyword;
      setState(() {});
    };
    widget.clear = () {
      widget._infos.clear();
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: widget._infos.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == widget._infos.length - 1) {
                    dynamicAppend();
                  }
                  return ListTile(
                    title: Text(
                        "${widget._infos[index].artist} - ${widget._infos[index].name}"),
                    onTap: () async {
                      Music? music = await getDetail(widget._infos[index]);
                      if (music != null) {
                        widget.playList.add(music);
                      }
                    },
                  );
                }))
      ],
    );
  }

  dynamicAppend() async {
    widget._infos
        .addAll(await KuwoApi().search(curKeyword, ++curIndex, pageSize));
    setState(() {
    });
  }

  Future<Music?> getDetail(MusicInfo info) async {
    return await KuwoApi().getDetail(info);
  }
}
