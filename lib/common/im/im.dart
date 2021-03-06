import 'package:flea_market/provider/global.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

class IM {
  static const String _appKey = '12410c88c67e2e68dde5fb7e';
  static final _userRegExp = RegExp(r"^user_([0-9]+)$");
  static String getUsername(int u) => 'user_$u';

  static int getUidByUsername(String username) {
    var match = _userRegExp.firstMatch(username);
    return int.parse(match.group(1));
  }

  static JMSingle _generateTargetInfo(String username) {
    var targetInfo = {
      'username': username,
      'appKey': _appKey,
    };
    return JMSingle.fromJson(targetInfo);
  }

  static JmessageFlutter client = JmessageFlutter();
  static JMUserInfo my;

  static void init() {
    client.init(isOpenMessageRoaming: true, appkey: _appKey);
    client.setDebugMode(enable: true);
  }

  static Future<void> login(int uid, String sid) async {
    await client.login(username: getUsername(uid), password: sid);
    my = await client.getMyInfo();
    client.addReceiveMessageListener(getUnreadMsgCounts);
    await getUnreadMsgCounts(null);
  }

  static Future<void> logout() async {
    client.removeReceiveMessageListener(getUnreadMsgCounts);
    my = null;
    client.logout();
  }

  static Future<void> register(int uid, String sid, String nickname, String avatarPath) async {
    await client.userRegister(username: getUsername(uid), password: sid, nickname: nickname);
    await login(uid, sid);
  }

  static Future getUnreadMsgCounts(dynamic _) async {
    int count = await client.getAllUnreadCount();
    GlobalModel.setUnreadMsgCount(count);
  }

  static Future<JMConversationInfo> createConversation(int uid) async {
    var target = _generateTargetInfo(getUsername(uid));
    var conversation = await client.createConversation(target: target);

    return conversation;
  }

  static Future<List<JMConversationInfo>> getConversationList() async {
    if (my == null) return [];
    var conversations = await client.getConversations();
    return conversations;
  }

  static Future<void> enterConversation(JMConversationInfo conversation) async {
    var target = _generateTargetInfo((conversation.target as JMUserInfo).username);
    await client.enterConversation(target: target);
  }

  static Future<void> exitConversation(JMConversationInfo conversation) async {
    var target = _generateTargetInfo((conversation.target as JMUserInfo).username);
    await client.exitConversation(target: target);
    await getUnreadMsgCounts(null);
  }

  static Future<String> getOriginalImage(JMImageMessage msg) async {
    var userInfo = msg.from.username == my.username ? msg.target as JMUserInfo : msg.from;
    var target = _generateTargetInfo(userInfo.username);
    var msgId = msg.id;
    var msgInfo = await client.downloadOriginalImage(target: target, messageId: msgId);
    return msgInfo['filePath'];
  }
}
