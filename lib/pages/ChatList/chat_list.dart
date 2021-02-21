import 'package:flea_market/common/config/routes.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/im/im.dart';
import 'package:flea_market/requests/index.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/provider/global.dart';
import 'package:flea_market/routers/index.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  int uid;
  List<JMConversationInfo> conversations = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    var data = await IM.getConversationList();
    data.removeWhere((info) => (info.target as JMUserInfo).username == IM.my.username);
    var uid = GlobalModel.uid;
    setState(() {
      this.conversations = data;
      this.uid = uid;
    });
  }

  getUserInfo(int target) async {
    return await () async {
      var data;
      await MyDio.get(ServiceUrl.userBriefUrl + '?uid=$target', (res) {
        data = res;
      }, (e) {
        Fluttertoast.showToast(msg: e);
      });
      return data;
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '聊天列表',
          style: TextStyle(color: Colors.black54),
        ),
        elevation: 3,
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios,
            color: Themes.primaryColor,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Themes.pageBackgroundColor,
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (ctx, i) {
          var conversation = conversations[i];
          JMUserInfo target = conversation.target;
          int targetUid = IM.getUidByUsername(target.username);
          JMNormalMessage lastMsg = conversation.latestMessage;
          String msgInfo = '';
          if (lastMsg.runtimeType == JMTextMessage) {
            var temp = lastMsg as JMTextMessage;
            msgInfo = temp.text;
          }
          if (lastMsg.runtimeType == JMImageMessage) {
            msgInfo = '[图片]';
          }
          return FutureBuilder(
            future: getUserInfo(targetUid),
            builder: (ctx, snapshot) {
              if (!snapshot.hasData) return Text('加载中');
              var targetInfo = snapshot.data['data'];
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black26,
                      width: 0.5,
                    ),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    MyRouter.router
                        .navigateTo(context, '${RoutesPath.conversationPage}?uid=$targetUid');
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 27,
                        backgroundImage:
                            NetworkImage('${ServiceUrl.uploadImageUrl}/${targetInfo['avatar']}'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            targetInfo['nickname'],
                            style: TextStyle(color: Colors.black87, fontSize: 21),
                          ),
                          Text(
                            msgInfo,
                            style: TextStyle(color: Colors.black45, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
