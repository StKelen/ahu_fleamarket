import 'package:flutter/material.dart';

import 'package:flea_market/common/config/theme.dart';

class TabBarItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  final int itemIndex;
  final Function changeSelectedIndex;

  TabBarItem(this.icon, this.text, this.itemIndex, this.selected,
      this.changeSelectedIndex, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      splashColor: Color(0xFFFFFFFF),
      highlightColor: Color(0x99FFFFFF),
      child: Container(
        child: Wrap(
          direction: Axis.vertical,
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 25,
              color: selected ? Themes.primaryColor : Themes.textColorSecondary,
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: 10,
                  height: 1.6,
                  color: selected ? Themes.primaryColor : Themes.textColorSecondary,
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
      onPressed: () {
        changeSelectedIndex(itemIndex);
      },
    );
  }
}
