import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flea_market/provider/global.dart';

import 'user_info.dart';
import 'login_navigator.dart';

class Person extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var token = Provider.of<GlobalModel>(context).getToken();
    return token == null || token == '' ? LoginNavigator() : UserInfo();
  }
}
