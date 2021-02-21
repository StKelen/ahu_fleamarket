import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/routes.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/routers/index.dart';

class ListItem extends StatelessWidget {
  final int did;
  final String image;
  final String title;
  final dynamic price;
  final String avatar;
  final String nickname;
  final String building;
  ListItem(this.did, this.image, this.title, this.price, this.avatar, this.nickname, this.building,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(2.w, 3.h),
            color: Color(0x44B2AEC1),
            blurRadius: 3.w,
          )
        ],
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: InkWell(
          onTap: () {
            MyRouter.router.navigateTo(context, RoutesPath.detailPage + '?did=$did');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(ServiceUrl.uploadImageUrl + '/$image'),
              Text(
                title,
                maxLines: 2,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32.sp,
                    letterSpacing: 1.sp,
                    color: Themes.textPrimaryColor),
              ),
              Text(
                ' ¥$price',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.sp,
                    height: 2.4.sp,
                    color: Colors.redAccent),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.h),
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(width: 0.5, color: Colors.black12))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 24.r,
                          backgroundImage: NetworkImage(ServiceUrl.uploadImageUrl + '/$avatar'),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          nickname,
                          style: TextStyle(color: Colors.black54, fontSize: 28.sp),
                        )
                      ],
                    ),
                    Text(
                      building,
                      style: TextStyle(color: Colors.black38, fontSize: 28.sp),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
