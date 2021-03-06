import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/requests/index.dart';

class UserInfo extends StatelessWidget {
  final int uid;
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  UserInfo({this.uid, Key key}) : super(key: key);

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
              CircleAvatar(
                radius: 100.r,
                backgroundImage: NetworkImage(ServiceUrl.uploadImageUrl + '/${data['avatar']}'),
              ),
              SizedBox(width: 30.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data['nickname'],
                    style: TextStyle(
                        fontSize: 58.sp,
                        fontWeight: FontWeight.bold,
                        color: Themes.textPrimaryColor),
                  ),
                  Text(
                    '居住在${data['building_name']}',
                    style: TextStyle(fontSize: 32.sp, color: Colors.black45),
                  )
                ],
              )
            ],
          );
        }
        return Container(
          child: child,
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.9, 1],
              colors: [Themes.accentColor, Themes.secondaryColor, Themes.pageBackgroundColor],
            ),
          ),
        );
      },
    );
  }
}
