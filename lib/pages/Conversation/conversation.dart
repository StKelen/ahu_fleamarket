import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/im/im.dart';

import 'bubble.dart';

class Conversation extends StatefulWidget {
  final int targetUid;
  Conversation(this.targetUid, {Key key}) : super(key: key);

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  JMConversationInfo conversation;
  List<ChatMessage> messages = [];
  ChatUser targetUser;
  ChatUser myUser;
  String title = '';

  void onReceiveMsg(msg) async {
    var m = msg as JMNormalMessage;
    if (m.from.username == (conversation.target as JMUserInfo).username) {
      var chatMsg = await messageHandler(m);
      setState(() {
        messages = [...messages, chatMsg];
      });
      _scrollToBottom();
    }
  }

  void init() async {
    if (IM.my == null) return;
    conversation = await IM.createConversation(widget.targetUid);
    var target = conversation.target as JMUserInfo;
    targetUser = ChatUser(
        name: target.nickname,
        uid: target.username,
        avatar: '${ServiceUrl.avatarUrl}?id=${widget.targetUid}');
    myUser = ChatUser(name: IM.my.nickname, uid: IM.my.username);
    var msgs = await conversation.getHistoryMessages(from: 0, limit: -1);
    var chatMsgs = List<ChatMessage>(msgs.length);
    for (var i = 0; i < msgs.length; i++) {
      chatMsgs[i] = await messageHandler(msgs[i]);
    }
    setState(() {
      title = target.nickname ?? '';
      messages = chatMsgs;
    });
    IM.client.addReceiveMessageListener(onReceiveMsg);
    await IM.enterConversation(conversation);
  }

  Future<ChatMessage> messageHandler(JMNormalMessage msg) async {
    var newMsg = ChatMessage(
        text: '',
        user: msg.from.username == targetUser.uid ? targetUser : myUser,
        createdAt: DateTime.fromMillisecondsSinceEpoch(msg.createTime).add(Duration(hours: 8)));

    switch (msg.runtimeType) {
      case (JMTextMessage):
        var m = msg as JMTextMessage;
        newMsg.text = m.text;
        break;
      case (JMImageMessage):
        var m = msg as JMImageMessage;
        newMsg.image = await IM.getOriginalImage(m);
        break;
    }
    return newMsg;
  }

  void onSendMsg(ChatMessage msg) async {
    await conversation.sendTextMessage(text: msg.text);
    setState(() {
      messages = [...messages, msg];
    });
    _scrollToBottom();
  }

  void handleSendImage() async {
    List<AssetEntity> assets = await AssetPicker.pickAssets(context,
        requestType: RequestType.image, pickerTheme: Theme.of(context));
    List<ChatMessage> newMsgs = [];
    for (var asset in assets) {
      var msg = await conversation.sendImageMessage(path: '${asset.relativePath}/${asset.title}');
      newMsgs.add(await messageHandler(msg));
    }
    setState(() {
      messages = [...messages, ...newMsgs];
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Timer(Duration(milliseconds: 500), () {
      _chatViewKey.currentState.scrollController.animateTo(
        _chatViewKey.currentState.scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _scrollToBottom();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    IM.client.removeReceiveMessageListener(onReceiveMsg);
    IM.exitConversation(conversation);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.pageBackgroundColor,
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.black54),
        ),
        elevation: 5,
        shadowColor: Colors.black26,
        centerTitle: true,
      ),
      body: DashChat(
        key: _chatViewKey,
        user: myUser,
        messages: messages,
        onLoadEarlier: () {},
        dateFormat: DateFormat("yyyy-MM-dd"),
        messageBuilder: (ChatMessage msg) {
          return Bubble(
            message: msg,
            isUser: msg.user.uid == myUser.uid,
          );
        },
        onSend: onSendMsg,
        trailing: [
          IconButton(
            icon: Icon(
              Icons.photo,
              color: Themes.primaryColor,
            ),
            onPressed: handleSendImage,
          )
        ],
      ),
    );
  }
}
