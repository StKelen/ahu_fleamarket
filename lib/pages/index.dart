import 'package:flutter/material.dart';

import 'package:flea_market/requests/index.dart';
import 'package:flea_market/routers/index.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/config/routes.dart';
import 'package:flea_market/common/iconfont/icon_font.dart';

import 'package:flea_market/widgets/bottom_tab_bar/bottom_tab_bar.dart';

import 'Home/home.dart';
import 'Person/person.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int prevIndex = 0;
  int selectedIndex = 0;
  final String primaryColorStr =
      '#' + Themes.primaryColor.value.toRadixString(16).substring(2);
  final String secondaryColorStr =
      '#' + Themes.textSecondaryColor.value.toRadixString(16).substring(2);

  get tabItems => <Map>[
        {
          "icon": IconFont(
            IconNames.home,
            size: 25,
            color: selectedIndex == 0 ? primaryColorStr : secondaryColorStr,
          ),
          "label": '首页'
        },
        {
          "icon": IconFont(
            IconNames.mine,
            size: 25,
            color: selectedIndex == 1 ? primaryColorStr : secondaryColorStr,
          ),
          "label": '我的'
        },
      ];

  final pages = <Widget>[Home(), Person()];

  void changeSelectedIndex(int index) {
    setState(() {
      prevIndex = selectedIndex;
      selectedIndex = index;
    });
  }

  void onClickUploadBtn() {
    MyRouter.router.navigateTo(context, RoutesPath.uploadPage);
  }

  @override
  void initState() {
    MyDio.addToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomTabBar(tabItems,
          prevIndex: prevIndex,
          selectedIndex: selectedIndex,
          changeSelectedIndex: changeSelectedIndex),
      backgroundColor: Themes.pageBackgroundColor,
      floatingActionButton: SizedBox(
        width: 45,
        height: 45,
        child: FloatingActionButton(
          child: IconFont(
            IconNames.jia,
            color: '#FFFFFF',
          ),
          backgroundColor: Themes.primaryColor,
          elevation: 0,
          highlightElevation: 0,
          onPressed: onClickUploadBtn,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
