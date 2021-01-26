import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flea_market/common/config/theme.dart';

PreferredSizeWidget getAppbar(ctx, search, getKeywords) {
  final controller = TextEditingController(text: search);
  controller.selection =
      TextSelection.fromPosition(TextPosition(offset: search.length));

  void submitSearch() {
    if (controller.text == '') {
      Fluttertoast.showToast(msg: '请输入关键词');
      return;
    }
    getKeywords(controller.text);
  }

  return AppBar(
    backgroundColor: Color(0xFFFFFFFF),
    elevation: 0,
    actions: [Container()],
    toolbarHeight: 60,
    automaticallyImplyLeading: false,
    title: Container(
      height: 40,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Themes.secondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(Icons.arrow_back_ios, color: Themes.primaryColor),
            onTap: () {
              Navigator.pop(ctx);
            },
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (val) => submitSearch(),
              decoration:
                  InputDecoration(hintText: '搜索闲置物品', border: InputBorder.none),
              style: TextStyle(fontSize: 18, height: 1.1),
              autofocus: true,
            ),
          ),
          InkWell(
            child: Icon(Icons.search, color: Themes.primaryColor),
            onTap: submitSearch,
          )
        ],
      ),
    ),
  );
}
