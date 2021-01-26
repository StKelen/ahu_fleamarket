import 'package:flutter/material.dart';

import 'package:flea_market/common/config/routes.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/routers/index.dart';
import 'package:flea_market/widgets/list/list.dart';
import 'package:flea_market/widgets/input/input.dart';

import 'category.dart';

class Home extends StatelessWidget {
  final _scrollController = ScrollController();
  final String url = '${ServiceUrl.listUrl}?';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0x00FFFFFF),
        elevation: 0,
        title: Input(
          icon: Icons.search,
          hintText: '搜索闲置物品',
          height: kToolbarHeight * 0.8,
          paddingHeight: 0,
          readOnly: true,
          onTap: () {
            MyRouter.router.navigateTo(context, RoutesPath.searchPage);
          },
        ),
        actions: [
          Container(
            child: IconButton(
              icon: Icon(Icons.mail_outline),
              onPressed: () {},
              color: Themes.primaryColor,
              iconSize: 32,
            ),
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          ),
        ],
      ),
      backgroundColor: Themes.pageBackgroundColor,
      body: ListView(
        controller: _scrollController,
        children: [Category(), DetailList(_scrollController, url)],
      ),
    );
  }
}
