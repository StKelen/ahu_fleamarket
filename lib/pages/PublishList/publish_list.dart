import 'package:flutter/material.dart';

import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/widgets/single_row_list/single_row_list.dart';

import 'publish_list_item.dart';

class PublishList extends StatelessWidget {
  final String _url = '${ServiceUrl.exchangeUrl}?type=publish&';

  Widget _itemBuilder(data, refresh) {
    return PublishListItem(
        data['detail_id'],
        data['status'],
        data['exchange_id'],
        data['target_id'],
        data['avatar'],
        data['nickname'],
        data['cover'],
        data['title'],
        data['price'],
        data['has_comment'],
        refresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('我发布的')),
      body: SingleRowList(this._url, this._itemBuilder),
    );
  }
}
