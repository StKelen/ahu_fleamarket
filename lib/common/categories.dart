import 'package:flutter/material.dart';

import 'iconfont/icon_font.dart';
import 'config/theme.dart';

Widget category(String icon, double size) {
  switch (icon) {
    case 'learning':
      return IconFont(IconNames.diqiuyi, size: size);
    case 'electricity':
      return IconFont(IconNames.erji, size: size);
    case 'exercise':
      return IconFont(IconNames.lanqiu, size: size);
    case 'fun':
      return IconFont(IconNames.fengche,size: size);
    case 'live':
      return IconFont(IconNames.taideng,size: size);
    case 'book':
      return IconFont(IconNames.yuedu,size: size);
    case 'cloth':
      return IconFont(IconNames.qunzi,size: size);
    case 'car':
      return IconFont(IconNames.qiche,size: size);
    case 'food':
      return IconFont(IconNames.quqi,size: size);
    default:
      return Icon(Icons.more_horiz, size: size, color: Themes.primaryColor);
  }
}
