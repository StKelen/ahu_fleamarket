import 'package:flutter/material.dart';

import 'package:flea_market/common/config/theme.dart';

class PrimaryButton extends StatelessWidget {
  final double minWidth;
  final double height;
  final String text;
  final double fontSize;
  final Function onPressed;

  PrimaryButton(
      {this.minWidth,
      this.height = 50,
      this.text,
      this.fontSize = 20,
      this.onPressed,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(
          height != null ? height / 2 : size.width * 0.12),
      child: FlatButton(
        minWidth: minWidth,
        height: height,
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Themes.secondaryColor, fontSize: fontSize),
        ),
        color: Themes.primaryColor,
      ),
    );
  }
}
