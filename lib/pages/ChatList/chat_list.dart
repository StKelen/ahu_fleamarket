import 'package:flea_market/common/config/routes.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/im/im.dart';
import 'package:flea_market/common/images.dart';
import 'package:flea_market/requests/index.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/provider/global.dart';
import 'package:flea_market/routers/index.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frefresh/frefresh.dart';
import 'package:fsuper/fsuper.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final FRefreshController _controller = FRefreshController();
  int uid;
  List<JMConversationInfo> conversations = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
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

  void _refresh() async {
    await _init();
    _controller.finishRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('聊天列表')),
      backgroundColor: Themes.pageBackgroundColor,
      body: FRefresh(
        controller: _controller,
        header: Center(
          child: Image.asset(
            Images.loading,
            fit: BoxFit.contain,
            height: 50.h,
            width: 50.h,
          ),
        ),
        headerHeight: 80.h,
        onRefresh: _refresh,
        child: ListView.builder(
          shrinkWrap: true,
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
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black26,
                        width: 0.5.h,
                      ),
                    ),
                  ),
                  child: InkWell(
                    onTap: () => MyRouter.router
                        .navigateTo(context, '${RoutesPath.conversationPage}?uid=$targetUid')
                        .then((_) => _refresh()),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 50.r,
                              backgroundImage: NetworkImage(
                                  '${ServiceUrl.uploadImageUrl}/${targetInfo['avatar']}'),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  targetInfo['nickname'],
                                  style: TextStyle(color: Colors.black87, fontSize: 34.sp),
                                ),
                                Text(
                                  msgInfo,
                                  style: TextStyle(color: Colors.black45, fontSize: 26.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                        FSuper(
                          redPoint: conversation.unreadCount != 0,
                          redPointText: '${conversation.unreadCount}',
                          redPointColor: Colors.redAccent,
                          redPointSize: 35.sp,
                          redPointOffset: Offset(1, 1),
                          redPointTextStyle: TextStyle(color: Colors.white, fontSize: 20.sp),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
