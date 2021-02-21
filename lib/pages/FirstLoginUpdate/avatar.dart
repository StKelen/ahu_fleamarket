import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/theme.dart';

class Avatar extends StatelessWidget {
  final ImageProvider image;
  final Function onTap;
  Avatar({this.image, this.onTap, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 45, vertical: 10.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            style: BorderStyle.solid,
            color: Themes.primaryColor,
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.face,
                color: Themes.primaryColor,
                size: 50.sp,
              ),
              SizedBox(width: 10),
              Text(
                '头像',
                style: TextStyle(color: Themes.textPrimaryColor, fontSize: 32.sp),
              )
            ],
          ),
          Container(
            width: 120.r,
            height: 120.r,
            // color: Color(0xFFFFFFFF),
            child: InkWell(
              child: CircleAvatar(backgroundImage: ResizeImage.resizeIfNeeded(null, null, image)),
              onTap: onTap,
              borderRadius: BorderRadius.circular(60.r),
            ),
          )
        ],
      ),
    );
  }
}
