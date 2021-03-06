import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flea_market/common/code/code.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/requests/index.dart';
import 'package:flea_market/widgets/primary_button/primary_button.dart';

class Comment extends StatelessWidget {
  final int eid;
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  final _descController = TextEditingController();

  Comment(this.eid, {Key key}) : super(key: key);

  _getDetail() => _memoizer.runOnce(() async {
        var data;
        await MyDio.get(ServiceUrl.detailBriefUrl + '?eid=$eid', (res) {
          data = res;
        }, (e) {
          EasyLoading.showError(e);
        });
        return data;
      });

  _uploadComment(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          title: Text('是否确认提价评价？'),
          actions: [
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                var comment = _descController.text;
                await MyDio.post(
                  ServiceUrl.commentUrl,
                  {
                    "exchange_id": eid,
                    "comment": comment,
                  },
                  (res) {
                    if (res['code'] != Code.Success) {
                      EasyLoading.showError('评价失败');
                      return;
                    }
                    EasyLoading.showSuccess('评价成功');
                    Navigator.pop(ctx);
                  },
                  (e) {
                    EasyLoading.showError(e);
                  },
                );
                Navigator.pop(ctx);
              },
            ),
            FlatButton(
              child: Text('还没有'),
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
      appBar: AppBar(title: Text('评价')),
      body: Column(
        children: [
          FutureBuilder(
            future: _getDetail(),
            builder: (ctx, snapshot) {
              if (!snapshot.hasData) return Container();
              if (snapshot.hasError) return Container();
              var data = snapshot.data['data'];

              var title = data['title'];
              var avatar = data['avatar'];
              var nickname = data['nickname'];
              var cover = data['cover'];
              var price = data['price'];

              return Container(
                color: Colors.white,
                height: 300.h,
                width: 750.w,
                margin: EdgeInsets.symmetric(vertical: 20.h),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    Row(
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
                          width: 480.w,
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
                  ],
                ),
              );
            },
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: TextField(
              controller: _descController,
              autofocus: false,
              style: TextStyle(fontSize: 32.sp),
              decoration: InputDecoration(
                  hintText: '写下你的交易评价吧~',
                  hintStyle: TextStyle(
                    color: Themes.textSecondaryColor,
                  ),
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
              maxLines: 8,
              cursorColor: Themes.primaryColor,
            ),
          ),
          SizedBox(height: 50.h),
          PrimaryButton(
            text: '发 表',
            width: 300.w,
            fontSize: 40.sp,
            height: 75.h,
            onPressed: () => _uploadComment(context),
          ),
        ],
      ),
    );
  }
}
