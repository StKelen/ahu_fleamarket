import 'package:fbutton/fbutton.dart';
import 'package:flutter/material.dart';

import 'package:flea_market/common/config/theme.dart';

class PrimaryButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final double fontSize;
  final Function onPressed;

  PrimaryButton(
      {this.width, this.height = 50, this.text, this.fontSize = 20, this.onPressed, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FButton(
      width: width,
      height: height,
      onPressed: onPressed,
      text: text,
      style: TextStyle(color: Themes.secondaryColor, fontSize: fontSize),
      color: Themes.primaryColor,
      corner: FCorner.all(height / 2),
      alignment: Alignment.center,
      clickEffect: true,
    );
  }
}
