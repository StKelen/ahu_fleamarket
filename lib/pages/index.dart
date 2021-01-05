import 'package:flutter/material.dart';
import 'package:flea_market/common/iconfont.dart';
import 'package:flea_market/widgets/BottomTabBar/bottom_tab_bar.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int selectedIndex = 0;

  void changeSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomTabBar(
          selectedIndex: selectedIndex,
          changeSelectedIndex: changeSelectedIndex),
      backgroundColor: Color(0xFFF7F8F3),
      floatingActionButton: SizedBox(
        width: 45,
        height: 45,
        child: FloatingActionButton(
          child: Icon(
            IconFont.icon_jia,
            size: 30,
          ),
          backgroundColor: Color(0xFF1CAE81),
          elevation: 0,
          highlightElevation: 0,
          onPressed: () {},
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
