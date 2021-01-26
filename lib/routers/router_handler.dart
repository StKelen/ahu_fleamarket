import 'package:flea_market/pages/Category/category.dart';
import 'package:flea_market/pages/Search/search.dart';
import 'package:fluro/fluro.dart';

import 'package:flea_market/pages/Login/login.dart';
import 'package:flea_market/pages/FirstLoginUpdate/first_login_update.dart';
import 'package:flea_market/pages/Upload/upload.dart';
import 'package:flea_market/pages/Detail/detail.dart';

Handler loginHandler = Handler(handlerFunc: (ctx, params) {
  return Login();
});

Handler firstLoginUpdateHandler = Handler(handlerFunc: (ctx, params) {
  return FirstLoginUpdate(
    sid: params['sid']?.first,
    name: params['name']?.first,
    sex: params['sex']?.first,
    mobile: params['mobile']?.first,
  );
});

Handler uploadHandler = Handler(handlerFunc: (ctx, params) {
  return Upload();
});

Handler detailHandler = Handler(handlerFunc: (ctx, params) {
  var didStr = params['did']?.first;
  return Detail(did: int.parse(didStr));
});

Handler categoryHandler = Handler(handlerFunc: (ctx, params) {
  var cidStr = params['cid']?.first;
  var name = params['name']?.first;
  return Category(int.parse(cidStr), name);
});

Handler searchHandler = Handler(handlerFunc: (ctx, params) {
  return Search();
});
