import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/theme.dart';

class Input extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final double height;
  final double paddingHeight;
  final bool readOnly;
  final bool isPassword;
  final Function onChanged;
  final Function onTap;

  const Input(
      {Key key,
      this.icon,
      this.hintText,
      this.readOnly = false,
      this.isPassword = false,
      this.paddingHeight = 5,
      this.height = 50,
      this.onChanged,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 0),
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      alignment: Alignment.center,
      width: 600.w,
      height: height,
      decoration: BoxDecoration(
        color: Themes.secondaryColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: TextField(
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        cursorColor: Themes.primaryColor,
        obscureText: isPassword,
        maxLines: 1,
        decoration: InputDecoration(
            icon: Icon(
              icon,
              color: Themes.primaryColor,
              size: 40.sp,
            ),
            hintText: hintText,
            border: InputBorder.none),
        style: TextStyle(fontSize: 34.sp),
      ),
    );
  }
}
