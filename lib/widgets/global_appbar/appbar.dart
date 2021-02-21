import 'package:flutter/material.dart';
import 'package:fsuper/fsuper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/config/routes.dart';
import 'package:flea_market/routers/index.dart';
import 'package:flea_market/provider/global.dart';
import 'package:flea_market/widgets/input/input.dart';

AppBar getGlobalAppBar(ctx) {
  var counts = Provider.of<GlobalModel>(ctx).getUnreadMsgCounts();
  return AppBar(
    backgroundColor: Color(0x00FFFFFF),
    toolbarHeight: 100.h,
    elevation: 0,
    title: Input(
      icon: Icons.search,
      hintText: '搜索闲置物品',
      height: 70.h,
      paddingHeight: 10.h,
      readOnly: true,
      onTap: () => MyRouter.router.navigateTo(ctx, RoutesPath.searchPage),
    ),
    actions: [
      Container(
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
        width: kToolbarHeight,
        child: GestureDetector(
          onTap: () => MyRouter.router.navigateTo(ctx, RoutesPath.chatListPage),
          child: FSuper(
            redPoint: counts != 0 && counts != null,
            redPointColor: Colors.redAccent,
            redPointText: '$counts',
            height: 70.h,
            width: 70.h,
            redPointSize: 35.sp,
            redPointTextStyle: TextStyle(color: Colors.white, fontSize: 20.sp),
            redPointOffset: Offset(0, 0),
            child1: Icon(
              Icons.mail_outline,
              color: Themes.primaryColor,
              size: 60.sp,
            ),
          ),
        ),
      ),
    ],
  );
}
