import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  /// 搜索动作回调
  final void Function(String) onSearch;

  const SearchBar({super.key, required this.onSearch});

  @override
  State<SearchBar> createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  String curText = "";

  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration:
            const InputDecoration(hintText: "Enter keyword and press enter"),
        onSubmitted: (value) {
          curText = value;
          widget.onSearch(value);
        });
  }
}
