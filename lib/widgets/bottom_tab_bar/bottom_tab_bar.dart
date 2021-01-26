import 'package:flutter/material.dart';

import 'tab_bar_item.dart';
import 'tab_bar_decoration.dart';

class BottomTabBar extends StatelessWidget {
  final List<Map> itemsData;
  final int prevIndex;
  final int selectedIndex;
  final Function changeSelectedIndex;

  BottomTabBar(this.itemsData,
      {this.selectedIndex = 0,
      this.prevIndex = 0,
      this.changeSelectedIndex,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int i = -1;
    var items = this.itemsData.map((val) {
      i++;
      return TabBarItem(val['icon'], val['label'], i, selectedIndex == i,
          changeSelectedIndex);
    }).toList();
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      elevation: 2,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 7, 0, 3),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            BottomBarDecoration(prevIndex, selectedIndex, items.length),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items,
            )
          ],
        ),
      ),
    );
  }
}
