import 'package:flutter/material.dart';

import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/widgets/list/list.dart';

import 'category.dart';

class Home extends StatelessWidget {
  final String _url = '${ServiceUrl.listUrl}?';

  @override
  Widget build(BuildContext context) {
    return DetailList(_url, widgetBefore: Category());
  }
}
