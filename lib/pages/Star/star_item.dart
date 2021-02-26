import 'package:fbutton/fbutton.dart';
import 'package:flea_market/common/code/code.dart';
import 'package:flea_market/common/config/routes.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/provider/global.dart';
import 'package:flea_market/requests/index.dart';
import 'package:flea_market/routers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class StarItem extends StatelessWidget {
  final String nickname;
  final String avatar;
  final String cover;
  final String title;
  final num price;
  final int sellerId;
  final int detailId;
  final Function refresh;

  StarItem(this.avatar, this.nickname, this.cover, this.title, this.price, this.sellerId,
      this.detailId, this.refresh,
      {Key key})
      : super(key: key);

  Widget _chatButton(BuildContext ctx) {
    return FlatButton(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(Icons.chat_outlined, size: 36.sp),
          SizedBox(width: 10.w),
          Text('联系卖家', style: TextStyle(fontSize: 30.sp))
        ],
      ),
      onPressed: () =>
          MyRouter.router.navigateTo(ctx, '${RoutesPath.conversationPage}?uid=$sellerId'),
    );
  }

  FButton _cancelStarButton(ctx) {
    return FButton(
      onPressed: () => _cancelStar(ctx),
      text: '取消收藏',
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      style: TextStyle(
        fontSize: 27.sp,
        color: Themes.textPrimaryColor,
        letterSpacing: 1.1,
      ),
      strokeWidth: 3.sp,
      strokeColor: Themes.primaryColor,
      corner: FCorner.all(25.h),
      alignment: Alignment.center,
      color: Colors.white,
      highlightColor: Colors.white,
      hoverColor: Colors.white,
      clickEffect: true,
    );
  }

  _cancelStar(BuildContext ctx) {
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          title: Text('是否确认取消收藏？'),
          actions: [
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                await MyDio.put(ServiceUrl.starUrl + '?did=$detailId', resolve: (res) {
                  if (res['code'] != Code.Success) {
                    Fluttertoast.showToast(msg: '确认失败');
                    return;
                  }
                  refresh();
                }, reject: (e) {
                  Fluttertoast.showToast(msg: '确认失败');
                });
                Navigator.pop(ctx);
              },
            ),
            FlatButton(
              child: Text('再考虑一下'),
              onPressed: () => Navigator.pop(ctx),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var uid = Provider.of<GlobalModel>(context).getUid();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: Colors.white,
        boxShadow: [BoxShadow(offset: Offset(2, 3), color: Color(0x44B2AEC1), blurRadius: 5)],
      ),
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('${ServiceUrl.uploadImageUrl}/$avatar'),
                radius: 30.r,
              ),
              SizedBox(width: 15.w),
              Text(
                nickname,
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(height: 12.h),
          detailId == 0
              ? Container(
                  height: 200.w,
                  alignment: Alignment.center,
                  child: Text(
                    '宝贝已被删除或已被卖出',
                    style: TextStyle(
                      fontSize: 34.sp,
                      letterSpacing: 1.1,
                      color: Themes.textSecondaryColor,
                    ),
                  ),
                )
              : Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(
                        '${ServiceUrl.uploadImageUrl}/$cover',
                        width: 200.w,
                        height: 200.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    SizedBox(
                      height: 180.w,
                      width: 430.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            title,
                            style: TextStyle(fontSize: 30.sp),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '¥$price',
                            style: TextStyle(
                              fontSize: 28.sp,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              uid == sellerId ? Container() : _chatButton(context),
              _cancelStarButton(context)
            ],
          )
        ],
      ),
    );
  }
}
