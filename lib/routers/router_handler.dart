import 'package:flea_market/pages/Comment/comment.dart';
import 'package:flea_market/pages/Profile/profile.dart';
import 'package:flea_market/pages/Star/star.dart';
import 'package:fluro/fluro.dart';

import 'package:flea_market/pages/Login/login.dart';
import 'package:flea_market/pages/FirstLoginUpdate/first_login_update.dart';
import 'package:flea_market/pages/Upload/upload.dart';
import 'package:flea_market/pages/Detail/detail.dart';
import 'package:flea_market/pages/BoughtList/bought_list.dart';
import 'package:flea_market/pages/Category/category.dart';
import 'package:flea_market/pages/ChatList/chat_list.dart';
import 'package:flea_market/pages/Conversation/conversation.dart';
import 'package:flea_market/pages/PublishList/publish_list.dart';
import 'package:flea_market/pages/Search/search.dart';

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

Handler chatListHandler = Handler(handlerFunc: (ctx, params) {
  return ChatList();
});

Handler conversationHandler = Handler(handlerFunc: (ctx, params) {
  var targetUid = int.parse(params['uid']?.first);
  return Conversation(targetUid);
});

Handler publishListHandler = Handler(handlerFunc: (ctx, params) {
  return PublishList();
});

Handler boughtListHandler = Handler(handlerFunc: (ctx, params) {
  return BoughtList();
});

Handler starListHandler = Handler(handlerFunc: (ctx, param) {
  return StarList();
});

Handler commentHandler = Handler(handlerFunc: (ctx, params) {
  var eid = int.parse(params['eid']?.first);
  return Comment(eid);
});

Handler profileHandler = Handler(handlerFunc: (ctx, params) {
  var uid = int.parse(params['uid']?.first);
  return Profile(uid);
});
