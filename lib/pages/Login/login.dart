import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flea_market/common/im/im.dart';
import 'package:flea_market/common/config/routes.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/images.dart';
import 'package:flea_market/common/code/code.dart';
import 'package:flea_market/provider/global.dart';
import 'package:flea_market/requests/index.dart';
import 'package:flea_market/routers/index.dart';

import 'package:flea_market/widgets/input/input.dart';
import 'package:flea_market/widgets/primary_button/primary_button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String sid = '';
  String password = '';
  final sidRegExp = RegExp(r'[A-Z][0-9]{4,7}');

  void onClickBack() => Navigator.pop(context);

  void onChangeUid(String value) => sid = value;

  void onChangePassword(String value) => password = value;

  void onLogin() async {
    var data = {
      'sid': sid,
      'password': password,
    };
    await MyDio.post(ServiceUrl.loginUrl, data, (res) async {
      int code = res['code'];
      if (code == Code.UpdateUserInfo) {
        var sid = Uri.encodeQueryComponent(res['data']['sid']);
        var name = Uri.encodeQueryComponent(res['data']['name']);
        var sex = Uri.encodeQueryComponent(res['data']['sex']);
        var mobile = Uri.encodeQueryComponent(res['data']['mobile']);
        var path = RoutesPath.firstLoginUpdatePage + '?sid=$sid&name=$name&sex=$sex&mobile=$mobile';
        MyRouter.router.navigateTo(context, path);
        return;
      }
      if (code != Code.Success) {
        Fluttertoast.showToast(msg: res['msg']);
        return;
      }
      int uid = res['data']['uid'];
      GlobalModel.setUserInfo(uid, sid);
      await IM.login(uid, sid);
      Fluttertoast.showToast(msg: '登录成功');
      Navigator.pop(context);
    }, (e) {
      Fluttertoast.showToast(
          msg: e, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, fontSize: 20);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Themes.primaryColor,
          splashColor: Color(0x00FFFFFF),
          highlightColor: Color(0x00FFFFFF),
          onPressed: onClickBack,
        ),
        backgroundColor: Color(0x00FFFFFF),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              Images.logo,
              width: 500.w,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: 40.h),
            Input(
              icon: Icons.person,
              height: 80.h,
              hintText: '智慧安大用户名',
              onChanged: onChangeUid,
            ),
            Input(
              icon: Icons.lock,
              height: 80.h,
              hintText: '智慧安大密码',
              isPassword: true,
              onChanged: onChangePassword,
            ),
            SizedBox(
              height: 20.h,
            ),
            PrimaryButton(
              width: 400.w,
              height: 80.h,
              text: '登 录',
              fontSize: 44.sp,
              onPressed: onLogin,
            )
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
      backgroundColor: Themes.pageBackgroundColor,
    );
  }
}
