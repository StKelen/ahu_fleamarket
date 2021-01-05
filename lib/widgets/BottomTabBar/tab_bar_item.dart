import 'package:flutter/material.dart';

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
      highlightColor: Color(0xFFFFFF),
      child: Container(
        width: 46,
        height: 46,
        alignment: Alignment.center,
        decoration: selected
            ? BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            color: Color(0xFFDDF3EC))
            : null,
        child: Wrap(
          direction: Axis.vertical,
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 25,
              color: selected ? Color(0xFF1CAE81) : Color(0xFFB2AEC1),
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: 10,
                  height: 1.6,
                  color: selected ? Color(0xFF1CAE81) : Color(0xFFB2AEC1),
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
