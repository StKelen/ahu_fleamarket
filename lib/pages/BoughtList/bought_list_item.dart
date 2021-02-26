import 'package:flutter/material.dart';
import 'package:fbutton/fbutton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/code/code.dart';
import 'package:flea_market/common/exchange_status.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/config/routes.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/requests/index.dart';
import 'package:flea_market/routers/index.dart';

class BoughtListItem extends StatelessWidget {
  final int eid;
  final int did;
  final int status;
  final int sellerId;
  final String avatarPath;
  final String nickname;
  final String cover;
  final String title;
  final num price;
  final bool hasComment;
  final Function refresh;
  BoughtListItem(this.did, this.status, this.eid, this.sellerId, this.avatarPath, this.nickname,
      this.cover, this.title, this.price, this.hasComment, this.refresh,
      {Key key})
      : super(key: key);

  String _statusTipHandler() {
    var currentStatus = ExchangeStatus.values[status];
    switch (currentStatus) {
      case ExchangeStatus.NoExchange:
        return '';
        break;
      case ExchangeStatus.BuyerStart:
        return '等待卖家接受请求';
        break;
      case ExchangeStatus.SellerStart:
        return '快进行线下交易吧';
        break;
      case ExchangeStatus.SellerConfirm:
        return '等待确认收货中';
        break;
      case ExchangeStatus.Finished:
        return '交易已完成';
        break;
      case ExchangeStatus.BuyerWantCancel:
        return '取消中，等待卖家确认';
        break;
      case ExchangeStatus.Cancelled:
        return '交易已取消';
        break;
      case ExchangeStatus.SellerRefuse:
        return '卖家拒绝交易';
        break;
    }
    return '获取交易状态失败';
  }

  FButton _fButtonWrapper({String text, Function onPressed, bool isHighlight = false}) {
    return FButton(
      onPressed: onPressed,
      text: text,
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 15.h),
      style: TextStyle(
        fontSize: 27.sp,
        color: isHighlight ? Colors.white : Themes.textPrimaryColor,
        letterSpacing: 1.1,
      ),
      strokeWidth: 3.sp,
      strokeColor: Themes.primaryColor,
      corner: FCorner.all(25.h),
      alignment: Alignment.center,
      color: isHighlight ? Themes.primaryColor : Colors.white,
      highlightColor: isHighlight ? Themes.primaryColor : Colors.white,
      hoverColor: isHighlight ? Themes.primaryColor : Colors.white,
      clickEffect: true,
    );
  }

  void _cancelRequest(ctx) {
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          title: Text('是否确认取消交易？'),
          actions: [
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                await MyDio.post(
                  ServiceUrl.exchangeUrl,
                  {
                    "new_status": ExchangeStatus.BuyerWantCancel.index,
                    "detail_id": did,
                    "exchange_id": eid
                  },
                  (res) {
                    if (res['code'] != Code.Success) {
                      Fluttertoast.showToast(msg: '确认失败');
                      return;
                    }
                    refresh();
                  },
                  (err) {
                    Fluttertoast.showToast(msg: '确认失败');
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

  void _confirmRequest(ctx) {
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          title: Text('是否确认已收货？'),
          actions: [
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                await MyDio.post(
                  ServiceUrl.exchangeUrl,
                  {
                    "new_status": ExchangeStatus.Finished.index,
                    "detail_id": did,
                    "exchange_id": eid
                  },
                  (res) {
                    if (res['code'] != Code.Success) {
                      Fluttertoast.showToast(msg: '确认失败');
                      return;
                    }
                    refresh();
                  },
                  (err) {
                    Fluttertoast.showToast(msg: '确认失败');
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

  void _deleteRequest(ctx) {
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          title: Text('是否确认删除？'),
          actions: [
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                await MyDio.delete(ServiceUrl.exchangeUrl,
                    data: {"exchange_id": eid, "detail_id": did}, resolve: (res) {
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
              child: Text('还没有'),
              onPressed: () => Navigator.pop(ctx),
            )
          ],
        );
      },
    );
  }

  Widget _actionBar(ctx) {
    var s = ExchangeStatus.values[status];
    switch (s) {
      case ExchangeStatus.NoExchange:
        return Container();
      case ExchangeStatus.BuyerStart:
        return _fButtonWrapper(text: '取消交易', onPressed: () => _cancelRequest(ctx));
        break;
      case ExchangeStatus.SellerStart:
        return _fButtonWrapper(text: '取消交易', onPressed: () => _cancelRequest(ctx));
        break;
      case ExchangeStatus.SellerConfirm:
        return Row(
          children: [
            _fButtonWrapper(text: '确认收货', onPressed: () => _confirmRequest(ctx), isHighlight: true),
            SizedBox(width: 10),
            _fButtonWrapper(text: '取消交易', onPressed: () => _cancelRequest(ctx)),
          ],
        );
        break;
      case ExchangeStatus.Finished:
        if (hasComment) return _fButtonWrapper(text: '删除', onPressed: () => _deleteRequest(ctx));
        return Row(children: [
          _fButtonWrapper(
              text: '评价',
              onPressed: () => MyRouter.router
                  .navigateTo(ctx, RoutesPath.commentPage + '?eid=$eid')
                  .then((_) => refresh()),
              isHighlight: true),
          SizedBox(width: 10),
          _fButtonWrapper(text: '删除', onPressed: () => _deleteRequest(ctx))
        ]);
        break;
      case ExchangeStatus.BuyerWantCancel:
        return Container();
        break;
      case ExchangeStatus.Cancelled:
        return _fButtonWrapper(text: '删除', onPressed: () => _deleteRequest(ctx));
        break;
      case ExchangeStatus.SellerRefuse:
        return _fButtonWrapper(text: '删除', onPressed: () => _deleteRequest(ctx));
        break;
    }
    return Container();
  }

  Widget _chatButton(BuildContext ctx) {
    return FlatButton(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(Icons.chat_outlined, size: 36.sp),
          SizedBox(width: 10.w),
          Text(
            '联系卖家',
            style: TextStyle(fontSize: 30.sp),
          )
        ],
      ),
      onPressed: () =>
          MyRouter.router.navigateTo(ctx, '${RoutesPath.conversationPage}?uid=$sellerId'),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              status == ExchangeStatus.NoExchange.index
                  ? Container()
                  : Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage('${ServiceUrl.uploadImageUrl}/$avatarPath'),
                          radius: 30.r,
                        ),
                        SizedBox(width: 15.w),
                        Text(
                          nickname,
                          style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
              Text(
                _statusTipHandler(),
                style: TextStyle(fontSize: 24.sp, color: Colors.redAccent),
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
                width: 450.w,
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
                          fontSize: 28.sp, color: Colors.red, fontWeight: FontWeight.bold),
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
              status == ExchangeStatus.NoExchange.index ? Container() : _chatButton(context),
              _actionBar(context)
            ],
          )
        ],
      ),
    );
  }
}
