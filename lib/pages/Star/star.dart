import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/pages/Star/star_item.dart';
import 'package:flea_market/widgets/single_row_list/single_row_list.dart';
import 'package:flutter/material.dart';

class StarList extends StatelessWidget {
  final String _url = '${ServiceUrl.exchangeUrl}?type=star&';

  Widget _itemBuilder(data, refresh) {
    return StarItem(data['avatar'], data['nickname'], data['cover'], data['title'], data['price'],
        data['user_id'], data['detail_id'], refresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('我的收藏')),
      body: SingleRowList(_url, _itemBuilder),
    );
  }
}
