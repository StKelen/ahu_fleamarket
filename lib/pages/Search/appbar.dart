import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/theme.dart';

PreferredSizeWidget getAppbar(ctx, search, getKeywords) {
  final controller = TextEditingController(text: search);
  controller.selection = TextSelection.fromPosition(TextPosition(offset: search.length));

  void submitSearch() {
    if (controller.text == '') {
      EasyLoading.showInfo('请输入关键词');
      return;
    }
    getKeywords(controller.text);
  }

  return AppBar(
    backgroundColor: Color(0xFFFFFFFF),
    elevation: 0,
    actions: [Container()],
    toolbarHeight: 100.h,
    automaticallyImplyLeading: false,
    title: Container(
      height: 70.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      decoration:
          BoxDecoration(color: Themes.secondaryColor, borderRadius: BorderRadius.circular(35.h)),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(Icons.arrow_back_ios, color: Themes.primaryColor, size: 42.sp),
            onTap: () => Navigator.pop(ctx),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (val) => submitSearch(),
              decoration: InputDecoration(hintText: '搜索闲置物品', border: InputBorder.none),
              style: TextStyle(fontSize: 32.sp),
              autofocus: true,
            ),
          ),
          InkWell(
            child: Icon(Icons.search, color: Themes.primaryColor, size: 42.sp),
            onTap: submitSearch,
          ),
        ],
      ),
    ),
  );
}
