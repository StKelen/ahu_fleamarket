import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'package:flea_market/pages/Login/login.dart';
import 'package:flea_market/pages/FirstLoginUpdate/first_login_update.dart';
import 'package:flea_market/pages/Upload/upload.dart';

Handler loginHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return Login();
});

Handler firstLoginUpdateHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return FirstLoginUpdate(
    sid: params['sid']?.first,
    name: params['name']?.first,
    sex: params['sex']?.first,
    mobile: params['mobile']?.first,
  );
});

Handler uploadHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Upload();
});
