import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/requests/index.dart';
import 'package:flea_market/common/config/routes.dart';
import 'package:flea_market/common/iconfont/icon_font.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/provider/global.dart';
import 'package:flea_market/routers/index.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  Map data;

  _getUserInfo() async {
    var responseData;
    await MyDio.get(ServiceUrl.profileUrl, (res) {
      setState(() {
        responseData = res['data'];
      });
    }, (e) {
      Fluttertoast.showToast(msg: e);
    });
    if (responseData != null) {
      setState(() {
        data = responseData;
      });
    } else {
      Fluttertoast.showToast(msg: '请求错误');
    }
  }

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<GlobalModel>(context).getUid();
    if (data == null) return Text('加载中');
    return Container(
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(20.w),
            padding: EdgeInsets.all(30.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(offset: Offset(2, 3), color: Color(0x44B2AEC1), blurRadius: 5)
                ]),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage('${ServiceUrl.uploadImageUrl}/${data['avatar']}'),
                  radius: 70.r,
                ),
                SizedBox(width: 20.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['nickname'],
                      style: TextStyle(
                        fontSize: 48.sp,
                        color: Themes.textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        data['sex'] == '男'
                            ? IconFont(IconNames.nan, size: 36.sp)
                            : IconFont(IconNames.nv, size: 36.sp),
                        SizedBox(width: 10.w),
                        Text(
                          '居住于${data['building']}',
                          style: TextStyle(color: Themes.textSecondaryColor, fontSize: 26.sp),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(20.w),
            padding: EdgeInsets.all(30.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(offset: Offset(2, 3), color: Color(0x44B2AEC1), blurRadius: 5)
                ]),
            child: Row(
              children: [
                ToolIcon(IconNames.gonglve, '我收藏的 ${data['star_count']}', ''),
                ToolIcon(IconNames.xinwen, '我发布的 ${data['publish_count']}',
                    '${RoutesPath.publishListPage}'),
                ToolIcon(IconNames.gouwu, '我买到的 ${data['bought_count']}',
                    '${RoutesPath.boughtListPage}'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ToolIcon extends StatelessWidget {
  final IconNames iconName;
  final String desc;
  final String path;
  ToolIcon(this.iconName, this.desc, this.path, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: MaterialButton(
        onPressed: () => MyRouter.router.navigateTo(context, path),
        child: Column(
          children: [
            IconFont(iconName, size: 90.sp),
            SizedBox(height: 5.h),
            Text(
              desc,
              style: TextStyle(color: Themes.textSecondaryColor, fontSize: 27.sp),
            )
          ],
        ),
      ),
    );
  }
}
