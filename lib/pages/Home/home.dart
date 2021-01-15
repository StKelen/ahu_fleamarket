import 'package:flutter/material.dart';

import 'package:flea_market/common/iconfont/icon_font.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/widgets/input/input.dart';
import 'package:flea_market/widgets/icon_button/icon_button.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0x00FFFFFF),
          elevation: 0,
          title: Input(
            icon: Icons.search,
            hintText: '搜索闲置物品',
            height: kToolbarHeight * 0.8,
            paddingHeight: 0,
          ),
          actions: [
            Container(
              child: IconButton(
                icon: Icon(Icons.mail_outline),
                onPressed: () {},
                color: Themes.primaryColor,
                iconSize: 32,
              ),
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            ),
          ],
        ),
        backgroundColor: Themes.pageBackgroundColor,
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(2, 3),
                      color: Color(0x44B2AEC1),
                      blurRadius: 5,
                    )
                  ]),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 5,
                children: <Widget>[
                  IconListButton(IconFont(IconNames.diqiuyi, size: 40), '学习用品'),
                  IconListButton(IconFont(IconNames.erji, size: 40), '电子产品'),
                  IconListButton(IconFont(IconNames.yuedu, size: 40), '图书'),
                  IconListButton(IconFont(IconNames.lanqiu, size: 40), '运动器材'),
                  IconListButton(IconFont(IconNames.qunzi, size: 40), '服装'),
                  IconListButton(IconFont(IconNames.qiche, size: 40), '拼车'),
                  IconListButton(IconFont(IconNames.quqi, size: 40), '食品'),
                  IconListButton(IconFont(IconNames.fengche, size: 40), '休闲娱乐'),
                  IconListButton(IconFont(IconNames.taideng, size: 40), '生活用品'),
                  IconListButton(
                      Icon(
                        Icons.more_horiz,
                        size: 40,
                        color: Themes.primaryColor,
                      ),
                      '更多')
                ],
              ),
            )
          ],
        ));
  }
}
