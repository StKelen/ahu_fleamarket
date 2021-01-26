import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/requests/index.dart';

import 'header.dart';

class Detail extends StatelessWidget {
  final int did;
  Detail({this.did, Key key}) : super(key: key);

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  getDetail() => _memoizer.runOnce(() async {
        var data;
        await MyDio.get(ServiceUrl.detailUrl + '?did=$did', (res) {
          data = res;
        }, (e) {
          Fluttertoast.showToast(msg: e);
        });
        return data;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0x00FFFFFF),
        elevation: 0,
        iconTheme: IconThemeData(color: Themes.primaryColor),
      ),
      body: Container(
        margin: EdgeInsets.zero,
        child: FutureBuilder(
          future: getDetail(),
          builder: (context, snapshot) {
            if (snapshot.data == null)
              return Center(
                child: Text(
                  '正在加载',
                  style:
                      TextStyle(color: Themes.textPrimaryColor, fontSize: 20),
                ),
              );
            var data = snapshot.data['data'];
            List images = data['images'];
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(uid: data['uid'], publishStr: data['publish_date']),
                  Text(
                    '¥${data['price']}',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    data['desc'],
                    style:
                        TextStyle(color: Themes.textPrimaryColor, fontSize: 22),
                  ),
                  SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: images.length,
                      itemBuilder: (ctx, i) {
                        return Container(
                          child: Image.network(
                              ServiceUrl.uploadImageUrl + '/${images[i]}'),
                          margin: EdgeInsets.symmetric(vertical: 3),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
