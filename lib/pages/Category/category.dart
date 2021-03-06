import 'package:flutter/material.dart';

import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/widgets/list/list.dart';

class Category extends StatelessWidget {
  final int cid;
  final String name;
  Category(this.cid, this.name, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('分类：$name'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DetailList('${ServiceUrl.listUrl}?cid=$cid&'),
    );
  }
}
