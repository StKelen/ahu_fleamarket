import 'package:flutter/material.dart';
import 'package:flea_market/common/iconfont.dart';

import './tab_bar_item.dart';

class BottomTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function changeSelectedIndex;

  BottomTabBar({this.selectedIndex = 0, this.changeSelectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        elevation: 2,
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 7, 0, 3),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TabBarItem(IconFont.icon_home, '首页', 0, selectedIndex == 0,
                  changeSelectedIndex),
              TabBarItem(IconFont.icon_mine, '我的', 1, selectedIndex == 1,
                  changeSelectedIndex),
            ],
          ),
        ));
  }
}
