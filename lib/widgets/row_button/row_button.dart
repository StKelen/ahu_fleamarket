import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/theme.dart';

class RowButton extends StatelessWidget {
  final String leadingText;
  final IconData leadingIcon;
  final String tailText;
  final Function onPressed;

  RowButton({this.leadingText, this.leadingIcon, this.tailText, this.onPressed, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      highlightColor: Color(0x00FFFFFF),
      padding: EdgeInsetsDirectional.only(start: 16.w, end: 12.w),
      onPressed: onPressed,
      child: Row(
        children: [
          Row(
            children: [
              Container(
                child: Icon(
                  leadingIcon,
                  size: 50.sp,
                  color: Themes.primaryColor,
                ),
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                    color: Themes.secondaryColor, borderRadius: BorderRadius.circular(30.r)),
                margin: EdgeInsets.fromLTRB(0, 0, 10.w, 0),
              ),
              Text(
                leadingText,
                style: TextStyle(
                    fontSize: 30.sp, fontWeight: FontWeight.bold, color: Themes.textPrimaryColor),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          Row(
            children: [
              Text(tailText,
                  style: TextStyle(
                      fontSize: 30.sp, color: Colors.redAccent, fontWeight: FontWeight.bold)),
              SizedBox(width: 10.w),
              Icon(
                Icons.arrow_forward_ios,
                size: 26.sp,
                color: Themes.textSecondaryColor,
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}
