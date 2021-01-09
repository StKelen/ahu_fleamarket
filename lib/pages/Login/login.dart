import 'package:flutter/material.dart';

import 'package:flea_market/common/images.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/widgets/input/input.dart';
import 'package:flea_market/widgets/primary_button/primary_button.dart';
import 'package:flea_market/requests/login.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String uid = '';
  String password = '';

  void onClickBack() {
    Navigator.pop(context);
  }

  void onChangeUid(String value) {
    uid = value;
  }

  void onChangePassword(String value) {
    password = value;
  }

  void onLogin() {
    postLoginRequest(uid, password, (c) {}, (c) {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          children: <Widget>[
            Image.asset(
              Images.logo,
              width: size.width * 0.7,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: size.height * 0.02),
            Input(
              icon: Icons.person,
              hintText: '智慧安大用户名',
              onChanged: onChangeUid,
            ),
            Input(
              icon: Icons.lock_outline,
              hintText: '智慧安大密码',
              isPassword: true,
              onChanged: onChangePassword,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            PrimaryButton(
              minWidth: size.width * 0.6,
              height: size.width * 0.12,
              text: '登录',
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
