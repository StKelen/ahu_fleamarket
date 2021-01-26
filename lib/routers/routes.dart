import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'router_handler.dart';
import 'package:flea_market/common/config/routes.dart';

class Routes {
  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return null;
    });
    router.define(RoutesPath.loginPage, handler: loginHandler);
    router.define(RoutesPath.firstLoginUpdatePage,
        handler: firstLoginUpdateHandler);
    router.define(RoutesPath.uploadPage, handler: uploadHandler);
    router.define(RoutesPath.detailPage, handler: detailHandler);
    router.define(RoutesPath.categoryPage, handler: categoryHandler);
    router.define(RoutesPath.searchPage, handler: searchHandler);
  }
}
