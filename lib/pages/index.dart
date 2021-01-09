import 'package:flutter/material.dart';

import 'package:flea_market/common/iconfont.dart';
import 'package:flea_market/common/config/theme.dart';
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

  final tabItems = <Map>[
    {"icon": IconFont.icon_home, "label": '首页'},
    {"icon": IconFont.icon_mine, "label": '我的'},
  ];

  final pages = <Widget>[Home(), Person()];

  void changeSelectedIndex(int index) {
    setState(() {
      prevIndex = selectedIndex;
      selectedIndex = index;
    });
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
          child: Icon(
            IconFont.icon_jia,
            size: 30,
          ),
          backgroundColor: Themes.primaryColor,
          elevation: 0,
          highlightElevation: 0,
          onPressed: () {
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
