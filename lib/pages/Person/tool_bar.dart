import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/provider/global.dart';

class ToolBar extends StatelessWidget {
  final _tools = [
    {
      "icon": Icons.logout,
      "text": "退出登录",
      "onPressed": _logout,
    }
  ];

  static Function _logout(BuildContext ctx) {
    return () {
      showDialog(
        context: ctx,
        barrierDismissible: true,
        builder: (ctx) {
          return AlertDialog(
            title: Text('是否确认退出登录？'),
            actions: [
              FlatButton(
                child: Text('确定'),
                onPressed: () async {
                  await GlobalModel.logout();
                  Navigator.pop(ctx);
                },
              ),
              FlatButton(
                child: Text('点错了'),
                onPressed: () => Navigator.pop(ctx),
              )
            ],
          );
        },
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      margin: EdgeInsets.only(top: 15.h),
      child: ListView.builder(
        itemCount: _tools.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (ctx, i) {
          return ToolBarItem(
            icon: _tools[i]["icon"],
            text: _tools[i]["text"],
            onPressed: (_tools[i]["onPressed"] as Function)(ctx),
          );
        },
      ),
    );
  }
}

class ToolBarItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onPressed;

  ToolBarItem({this.icon, this.text, this.onPressed, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Themes.textSecondaryColor),
          bottom: BorderSide(color: Themes.textSecondaryColor),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 20.h,
      ),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 48.sp,
                    color: Themes.primaryColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    text,
                    style: TextStyle(fontSize: 32.sp, color: Themes.textPrimaryColor),
                  )
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 24.sp, color: Themes.textSecondaryColor)
          ],
        ),
      ),
    );
  }
}
