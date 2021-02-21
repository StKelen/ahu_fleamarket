import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/code/code.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/config/routes.dart';
import 'package:flea_market/common/exchange_status.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/pages/Detail/star.dart';
import 'package:flea_market/provider/global.dart';
import 'package:flea_market/routers/index.dart';
import 'package:flea_market/requests/index.dart';
import 'package:flea_market/widgets/primary_button/primary_button.dart';

import 'header.dart';

class Detail extends StatelessWidget {
  final int did;
  Detail({this.did, Key key}) : super(key: key);

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  getDetail() => _memoizer.runOnce(() async {
        var data;
        await MyDio.get(ServiceUrl.detailUrl + '?did=$did', (res) {
          data = res;
        }, (e) {
          Fluttertoast.showToast(msg: e);
        });
        return data;
      });

  chat(BuildContext context, int uid) async {
    MyRouter.router.navigateTo(context, '${RoutesPath.conversationPage}?uid=$uid');
  }

  void handleBuy(BuildContext ctx) {
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          title: Text('是否确认购买？'),
          actions: [
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                MyDio.post(
                  ServiceUrl.exchangeUrl,
                  {"new_status": ExchangeStatus.BuyerStart.index, "detail_id": did},
                  (res) {
                    if (res['code'] != Code.Success) {
                      Fluttertoast.showToast(msg: '购买失败');
                      return;
                    }
                  },
                  (err) {
                    Fluttertoast.showToast(msg: '购买失败');
                  },
                );
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        iconTheme: IconThemeData(color: Themes.primaryColor),
        title: Text('详情'),
      ),
      backgroundColor: Themes.pageBackgroundColor,
      body: FutureBuilder(
        future: getDetail(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Text(
                '正在加载',
                style: TextStyle(color: Themes.textPrimaryColor, fontSize: 20),
              ),
            );
          var data = snapshot.data['data'];
          List images = data['images'];
          return Container(
            height: 1334.h,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Header(uid: data['uid'], publishStr: data['publish_date']),
                      Text(
                        '¥${data['price']}',
                        style: TextStyle(
                            color: Colors.red, fontSize: 42.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        data['desc'],
                        style: TextStyle(
                            color: Themes.textPrimaryColor, fontSize: 34.sp, letterSpacing: 1.2),
                      ),
                      SizedBox(height: 30.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40.r),
                        child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: images.length,
                          itemBuilder: (ctx, i) {
                            return Container(
                              child: Image.network(ServiceUrl.uploadImageUrl + '/${images[i]}'),
                              margin: EdgeInsets.only(bottom: 3.h),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 60.h),
                    ],
                  ),
                ),
                Positioned(
                  width: 750.w,
                  bottom: 0,
                  height: 80.h,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(blurRadius: 9, offset: Offset(0, 3), color: Colors.black26)
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Star(did),
                        Provider.of<GlobalModel>(context).getUid() == data['uid']
                            ? Container()
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PrimaryButton(
                                    height: 60.h,
                                    width: 160.w,
                                    fontSize: 26.h,
                                    text: '立即购买',
                                    onPressed: () => handleBuy(context),
                                  ),
                                  SizedBox(width: 20.w),
                                  PrimaryButton(
                                    height: 60.h,
                                    width: 160.w,
                                    fontSize: 26.h,
                                    text: '聊一聊',
                                    onPressed: () => chat(context, data['uid']),
                                  )
                                ],
                              )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
