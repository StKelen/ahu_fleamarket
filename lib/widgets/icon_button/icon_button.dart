import 'package:flutter/material.dart';

import 'package:flea_market/common/config/theme.dart';

class IconListButton extends StatelessWidget {
  final Widget icon;
  final String text;

  IconListButton(this.icon, this.text, {Key key}) : super(key: key);

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
            icon,
            Text(
              text,
              style: TextStyle(
                  fontSize: 14, height: 1.6, color: Themes.textPrimaryColor),
            )
          ],
        ),
      ),
      onPressed: () {},
    );
  }
}
