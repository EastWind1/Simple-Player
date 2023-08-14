import 'package:flutter/cupertino.dart';
import 'package:simple_player/common/event_bus.dart';
import 'package:simple_player/service/kugou_api.dart';
import 'package:simple_player/service/kuwo_api.dart';
import 'package:simple_player/service/platform_api.dart';
import 'package:simple_player/view/search/search_bar.dart';
import 'package:simple_player/view/search/search_result_list.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final GlobalKey<SearchBarState> searchBarKey = GlobalKey();
  final GlobalKey<SearchResultListState> searchResultListKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(key: searchBarKey, onSearch: onSearch),
        SearchResultList(
            key: searchResultListKey,
            pageSize: 20,
            dynamicAdd: dynamicAdd,
            itemTap: itemTap)
      ],
    );
  }

  /// 搜索动作回调
  onSearch(String keyWorld) {
    KugouApi()
        .search(keyWorld, 0, 20)
        .then((value) => searchResultListKey.currentState?.addAll(value));
  }

  /// 结果动态滚动添加
  Future<List<MusicInfo>> dynamicAdd(int pageIndex, int pageSize) async {
    String? curKey = searchBarKey.currentState?.curText;
    if (curKey == null || curKey.isEmpty) {
      return [];
    }
    return await KugouApi().search(curKey, pageIndex, pageSize);
  }

  /// 列表项点击
  itemTap(MusicInfo info) {
    KuwoApi().getDetail(info).then((value) {
      if (value != null) {
        EventBus().addAndPlay.sink.add(value);
      }
    });
  }
}
