import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/requests/index.dart';

class Header extends StatelessWidget {
  final int uid;
  final String publishStr;
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  Header({this.uid, this.publishStr, Key key}) : super(key: key);
  getUserInfo() {
    return _memoizer.runOnce(() async {
      var data;
      await MyDio.get(ServiceUrl.userBriefUrl + '&uid=$uid', (res) {
        data = res;
      }, (e) {
        Fluttertoast.showToast(msg: e);
      });
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserInfo(),
      builder: (ctx, snapshot) {
        Widget child;
        if (snapshot.data != null) {
          var data = snapshot.data['data'];
          child = Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      ServiceUrl.uploadImageUrl + '/${data['avatar']}'),
                ),
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data['nickname'],
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Themes.textPrimaryColor),
                  ),
                  Text(
                    '居住在${data['building_name']}，$publishStr',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  )
                ],
              )
            ],
          );
        }
        return Container(
          height: 80,
          child: child,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 10),
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                style: BorderStyle.solid,
                color: Colors.black12,
                width: 1,
              ),
            ),
          ),
        );
      },
    );
  }
}
