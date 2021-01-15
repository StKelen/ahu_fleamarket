import 'package:flutter/material.dart';

import 'package:flea_market/common/config/theme.dart';

class RowButton extends StatelessWidget {
  final String leadingText;
  final IconData leadingIcon;
  final String tailText;
  final Function onPressed;

  RowButton(
      {this.leadingText,
      this.leadingIcon,
      this.tailText,
      this.onPressed,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        highlightColor: Color(0x00FFFFFF),
        onPressed: onPressed,
        child: Row(
          children: [
            Row(
              children: [
                Container(
                  child: Icon(
                    leadingIcon,
                    size: 24,
                    color: Themes.primaryColor,
                  ),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Themes.secondaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                ),
                Text(
                  leadingText,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Themes.textPrimaryColor),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            Row(
              children: [
                Text(tailText,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Themes.textSecondaryColor,
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ));
  }
}
