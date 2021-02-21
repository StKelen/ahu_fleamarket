import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flea_market/common/im/im.dart';
import 'package:flea_market/requests/index.dart';

class GlobalModel with ChangeNotifier {
  String _token;
  static int _uid;
  static String _sid;
  int _unreadMsgCount;
  static BuildContext _ctx;
  static SharedPreferences _sp;

  void init(ctx) async {
    _ctx = _ctx ?? ctx;
    IM.init();
    _sp = await SharedPreferences.getInstance();
    var t = _sp.getString('Token');
    if (t != null && t != '') {
      MyDio.setToken(t);
      _token = t;
    }
    var u = _sp.getInt('uid');
    var s = _sp.getString('sid');
    if (u != null && s != null && s != '') {
      _uid = u;
      _sid = s;
      await IM.login(u, s);
    }
  }

  static setToken(String t) {
    Provider.of<GlobalModel>(_ctx, listen: false)._setToken(t);
  }

  static setUnreadMsgCount(int c) {
    Provider.of<GlobalModel>(_ctx, listen: false)._setUnreadMsgCounts(c);
  }

  static setUserInfo(int uid, String sid) {
    Provider.of<GlobalModel>(_ctx, listen: false)._setUserInfo(uid, sid);
  }

  static get uid => _uid;

  _setToken(String t) {
    if (t != null && t != '') {
      _token = t;
      MyDio.setToken(t);
      _sp.setString('Token', t);
      notifyListeners();
    }
  }

  getToken() => _token;
  getUid() => _uid;

  getUnreadMsgCounts() => _unreadMsgCount;

  void _setUserInfo(int u, String s) {
    if (u != null && u != _uid && s != null && _sid != s && s != '') {
      _sid = s;
      _uid = u;
      _sp.setInt('uid', u);
      _sp.setString('sid', s);
      notifyListeners();
    }
  }

  _setUnreadMsgCounts(int c) {
    if (c != null) {
      _unreadMsgCount = c;
      notifyListeners();
    }
  }
}
