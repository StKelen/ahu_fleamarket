import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/config/routes.dart';
import 'package:flea_market/routers/index.dart';
import 'package:flea_market/requests/index.dart';

class Header extends StatelessWidget {
  final int uid;
  final String publishStr;
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  Header({this.uid, this.publishStr, Key key}) : super(key: key);
  getUserInfo() {
    return _memoizer.runOnce(() async {
      var data;
      await MyDio.get(ServiceUrl.userBriefUrl + '?uid=$uid', (res) {
        data = res;
      }, (e) {
        EasyLoading.showError(e);
      });
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserInfo(),
      builder: (ctx, snapshot) {
        Widget child;
        if (snapshot.data != null) {
          var data = snapshot.data['data'];
          child = Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 90.w,
                height: 90.w,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(ServiceUrl.uploadImageUrl + '/${data['avatar']}'),
                ),
              ),
              SizedBox(width: 20.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data['nickname'],
                    style: TextStyle(
                        fontSize: 38.sp,
                        fontWeight: FontWeight.bold,
                        color: Themes.textPrimaryColor),
                  ),
                  Text(
                    '居住在${data['building_name']}，$publishStr',
                    style: TextStyle(fontSize: 25.sp, color: Colors.black54),
                  )
                ],
              )
            ],
          );
        }
        return Container(
          height: 100.h,
          child: InkWell(
            child: child,
            onTap: () => MyRouter.router.navigateTo(context, '${RoutesPath.profilePage}?uid=$uid'),
          ),
          padding: EdgeInsets.fromLTRB(5.w, 0, 0, 15.h),
          margin: EdgeInsets.only(bottom: 15.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                style: BorderStyle.solid,
                color: Colors.black12,
                width: 1,
              ),
            ),
          ),
        );
      },
    );
  }
}
