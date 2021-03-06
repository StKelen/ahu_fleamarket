import 'package:flutter/material.dart';

import 'package:flea_market/routers/index.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/config/routes.dart';
import 'package:flea_market/common/iconfont/icon_font.dart';
import 'package:flea_market/common/im/im.dart';

import 'package:flea_market/widgets/global_appbar/appbar.dart';
import 'package:flea_market/widgets/bottom_tab_bar/bottom_tab_bar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Home/home.dart';
import 'Person/person.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int prevIndex = 0;
  int selectedIndex = 0;
  final String primaryColorStr = '#' + Themes.primaryColor.value.toRadixString(16).substring(2);
  final String secondaryColorStr =
      '#' + Themes.textSecondaryColor.value.toRadixString(16).substring(2);

  get tabItems => [
        {
          "icon": IconFont(
            IconNames.home,
            size: 50.sp,
            color: selectedIndex == 0 ? primaryColorStr : secondaryColorStr,
          ),
          "label": '首页'
        },
        {
          "icon": IconFont(
            IconNames.mine,
            size: 50.sp,
            color: selectedIndex == 1 ? primaryColorStr : secondaryColorStr,
          ),
          "label": '我的'
        },
      ];

  final pages = [Home(), Person()];

  void changeSelectedIndex(int index) => setState(() {
        prevIndex = selectedIndex;
        selectedIndex = index;
      });

  void onClickUploadBtn() {
    if (IM.my == null) {
      EasyLoading.showInfo('请登录~');
      MyRouter.router.navigateTo(context, RoutesPath.loginPage);
      return;
    }
    MyRouter.router.navigateTo(context, RoutesPath.uploadPage);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    ScreenUtil.init(BoxConstraints(maxWidth: size.width, maxHeight: size.height),
        designSize: Size(750, 1334), allowFontScaling: false);

    return Scaffold(
      appBar: getGlobalAppBar(context),
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
