import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'package:flea_market/pages/Login/login.dart';

Handler LoginHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return Login();
});
