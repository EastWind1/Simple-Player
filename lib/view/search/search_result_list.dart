import 'package:flutter/material.dart';
import 'package:simple_player/service/platform_api.dart';

/// 搜索结果页
class SearchResultList extends StatefulWidget {
  /// 列表动态加载方法
  ///
  /// 传入当前页索引，页大小
  ///
  /// 返回List<Music>
  final Future<List<MusicInfo>> Function(int, int) dynamicAdd;

  /// 列表项点击事件
  ///
  /// 传入所点击的Music
  final Function(MusicInfo) itemTap;

  /// 页大小
  final int pageSize;

  const SearchResultList(
      {super.key,
      required this.pageSize,
      required this.dynamicAdd,
      required this.itemTap});

  @override
  State<SearchResultList> createState() => SearchResultListState();
}

class SearchResultListState extends State<SearchResultList> {
  /// 当前列表数据
  final List<MusicInfo> _items = [];

  /// 当前页索引
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == _items.length - 1) {
                    // 滚动至底部动态添加
                    widget
                        .dynamicAdd(++pageIndex, widget.pageSize)
                        .then((value) {
                      _items.addAll(value);
                      setState(() {});
                    });
                  }
                  return ListTile(
                    title:
                        Text("${_items[index].artist} - ${_items[index].name}"),
                    onTap: () {
                      widget.itemTap(_items[index]);
                    },
                  );
                }))
      ],
    );
  }

  /// 添加项
  ///
  /// 传入要添加的List<Music>
  void addAll(List<MusicInfo> list) {
    _items.addAll(list);
    setState(() {});
  }

  /// 清空项
  void clear() {
    _items.clear();
    setState(() {});
  }
}
