import 'package:flutter/material.dart';

import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/widgets/single_row_list/single_row_list.dart';

import 'bought_list_item.dart';

class BoughtList extends StatelessWidget {
  final String _url = '${ServiceUrl.exchangeUrl}?type=bought&';

  Widget _itemBuilder(data, refresh) {
    return BoughtListItem(data['detail_id'], data['status'], data['exchange_id'], data['target_id'],
        data['avatar'], data['nickname'], data['cover'], data['title'], data['price'], refresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('我买到的')),
      body: SingleRowList(this._url, this._itemBuilder),
    );
  }
}
