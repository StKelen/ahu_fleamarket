import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/images.dart';
import 'package:flea_market/common/config/routes.dart';
import 'package:flea_market/routers/index.dart';
import 'package:flea_market/widgets/primary_button/primary_button.dart';

class LoginNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            Images.logo,
            width: 500.w,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: 80.h),
          PrimaryButton(
            width: 400.w,
            height: 80.h,
            text: '智慧安大登录',
            fontSize: 44.sp,
            onPressed: () => MyRouter.router.navigateTo(context, RoutesPath.loginPage),
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}
