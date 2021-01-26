import 'package:flutter/material.dart';

import 'package:flea_market/common/images.dart';
import 'package:flea_market/common/config/routes.dart';
import 'package:flea_market/routers/index.dart';

import 'package:flea_market/widgets/primary_button/primary_button.dart';

class Person extends StatefulWidget {
  @override
  _PersonState createState() => _PersonState();
}

class _PersonState extends State<Person> {
  void onPressLoginBtn() {
    MyRouter.router.navigateTo(context, RoutesPath.loginPage);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: <Widget>[
          Image.asset(
            Images.logo,
            width: size.width * 0.7,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: size.height * 0.08),
          PrimaryButton(
            minWidth: size.width * 0.6,
            height: size.width * 0.12,
            text: '智 慧 安 大 登 录',
            fontSize: 25,
            onPressed: onPressLoginBtn,
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}
