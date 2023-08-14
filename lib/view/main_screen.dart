import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_player/view/player/player_page.dart';
import 'package:simple_player/view/search/search_page.dart';

/// 导航
class Navigation extends StatefulWidget {
  const Navigation({super.key});
  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  // 当前页索引
  int currentPageIndex = 0;
  // 外部声明，避免切换tap状态消失
  List<Widget> pages = [
    SearchPage(),
    PlayerPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          // 搜索页标签
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          // 播放器标签
          NavigationDestination(
            icon: Icon(Icons.play_arrow),
            label: 'Player',
          )
        ],
      ),
      // 使用IndexedStack，避免切换tap状态消失
      body: IndexedStack(index: currentPageIndex, children: pages)
    );
  }
}
