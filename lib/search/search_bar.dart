import 'package:flutter/material.dart';
import 'package:simple_player/search/search_result.dart';
import 'package:simple_player/service/kuwo_api.dart';

class SearchBar extends StatefulWidget {
  final SearchResult searchResult;
  const SearchBar({Key? key, required this.searchResult}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              child: TextField(
                  decoration: const InputDecoration(hintText: "搜索"),
                  onSubmitted: (value) async {
                    widget.searchResult.clear();
                    widget.searchResult.search(value);
                  }))
        ],
      ),
    );
  }
}
