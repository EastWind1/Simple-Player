// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:simple_player/player/player.dart';
import 'package:simple_player/player/playlist.dart';
import 'package:simple_player/search/search_bar.dart';
import 'package:simple_player/search/search_result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late PlayList _playList;
  late SearchResult _searchResult;

  MyApp({super.key}) {
    _playList = PlayList();
    _searchResult = SearchResult(playList: _playList);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: Scaffold(
        body: Stack(children: [
          Column(
            children: [
              SizedBox(height: 50, child: SearchBar(searchResult: _searchResult)),
              Expanded(child: _searchResult)
            ],
          ),
          Player(playList: _playList)
        ]),
      ),
    );
  }
}
