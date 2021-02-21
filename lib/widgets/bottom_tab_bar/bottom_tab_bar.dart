import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'tab_bar_item.dart';
import 'tab_bar_decoration.dart';

class BottomTabBar extends StatelessWidget {
  final List<Map> itemsData;
  final int prevIndex;
  final int selectedIndex;
  final Function changeSelectedIndex;

  BottomTabBar(this.itemsData,
      {this.selectedIndex = 0, this.prevIndex = 0, this.changeSelectedIndex, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int i = -1;
    var items = this.itemsData.map((val) {
      i++;
      return TabBarItem(val['icon'], val['label'], i, selectedIndex == i, changeSelectedIndex);
    }).toList();
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      elevation: 2,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 14.w, 0, 6.w),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            BottomBarDecoration(prevIndex, selectedIndex, items.length),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items,
            )
          ],
        ),
      ),
    );
  }
}
