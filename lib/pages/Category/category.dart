import 'package:flutter/material.dart';

import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/widgets/list/list.dart';

class Category extends StatefulWidget {
  final int cid;
  final String name;
  Category(this.cid, this.name, {Key key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final _scrollController = ScrollController();
  String url;

  @override
  void initState() {
    url = '${ServiceUrl.listUrl}?cid=${widget.cid}&';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('分类：${widget.name}')),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: DetailList(_scrollController, url),
      ),
    );
  }
}
