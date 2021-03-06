import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/widgets/category_dropdown/category_dropdown.dart';

import 'building.dart';

class SearchDrawer extends StatefulWidget {
  final Function getFilterInfo;
  SearchDrawer({this.getFilterInfo, Key key}) : super(key: key);
  @override
  _SearchDrawerState createState() => _SearchDrawerState();
}

class _SearchDrawerState extends State<SearchDrawer> {
  final _drawerKey = GlobalKey();
  final moneyRegexp = RegExp(r'^(0|[1-9][0-9]*)\.?[0-9]{0,2}$');
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  int bid = 0;
  Widget buildingTail;
  int cid = 0;
  Widget categoryTail;

  void onChangeCategory(value) {
    setState(() {
      cid = value['cid'];
      categoryTail = Text(value['name']);
    });
  }

  void onChangeBuilding(value) {
    setState(() {
      bid = value['bid'];
      buildingTail = Text(value['name']);
    });
  }

  void onSubmit() {
    var minPriceStr = _minPriceController.text;
    var maxPriceStr = _maxPriceController.text;
    double minPrice;
    double maxPrice;
    if (minPriceStr != '') {
      if (!moneyRegexp.hasMatch(minPriceStr)) {
        EasyLoading.showError('最低价格格式错误');
        return;
      }
      minPrice = double.parse(minPriceStr);
    }
    if (maxPriceStr != '') {
      if (!moneyRegexp.hasMatch(maxPriceStr)) {
        EasyLoading.showError('最高价格格式错误');
        return;
      }
      maxPrice = double.parse(maxPriceStr);
    }
    widget.getFilterInfo(bid, cid, minPrice, maxPrice);
  }

  void onReset() {
    _minPriceController.clear();
    _maxPriceController.clear();
    setState(() {
      bid = 0;
      cid = 0;
      buildingTail = null;
      categoryTail = null;
    });
    widget.getFilterInfo(bid, cid, null, null);
  }

  @override
  Widget build(BuildContext context) {
    var drawerWidth =
        _drawerKey?.currentContext?.findRenderObject()?.paintBounds?.size?.width ?? 304.0;
    return Drawer(
      key: _drawerKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
        child: Stack(children: [
          ListView(children: [
            Text('公寓选择',
                style: TextStyle(
                    fontSize: 36.sp, fontWeight: FontWeight.w900, color: Themes.primaryColor)),
            BuildingDropdown(
                leadingIcon: Icons.home_work,
                leadingText: '公寓',
                tail: buildingTail,
                onChanged: onChangeBuilding),
            SizedBox(height: 70.h),
            Text('分类选择',
                style: TextStyle(
                    fontSize: 36.sp, fontWeight: FontWeight.w900, color: Themes.primaryColor)),
            CategoryDropdown(
                leadingIcon: Icons.category,
                tail: categoryTail,
                leadingText: '分类',
                onChanged: onChangeCategory),
            SizedBox(height: 70.h),
            Text('价格',
                style: TextStyle(
                    fontSize: 36.sp, fontWeight: FontWeight.w900, color: Themes.primaryColor)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                  child: PriceInput(
                    label: '最低价格',
                    controller: _minPriceController,
                  ),
                  flex: 4),
              Expanded(
                  child: Text('~',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold,
                          color: Themes.textPrimaryColor)),
                  flex: 1),
              Expanded(
                  child: PriceInput(
                    label: '最高价格',
                    controller: _maxPriceController,
                  ),
                  flex: 4)
            ])
          ]),
          Positioned(
            bottom: 20,
            width: drawerWidth - 20,
            child: Container(
              height: 100.h,
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.r),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Themes.primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50.h),
                          topLeft: Radius.circular(50.h),
                        ),
                      ),
                      child: MaterialButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Text('重置',
                            style: TextStyle(
                                color: Themes.textPrimaryColor,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 6)),
                        onPressed: onReset,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Themes.primaryColor,
                        border: Border.all(
                          color: Themes.primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50.h),
                          bottomRight: Radius.circular(50.h),
                        ),
                      ),
                      child: MaterialButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Text(
                          '确定',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 6),
                        ),
                        onPressed: onSubmit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class PriceInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final moneyRegexp = RegExp(r'^(0|[1-9][0-9]*)\.?[0-9]{0,2}$');
  PriceInput({this.label, this.controller, Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Themes.secondaryColor,
        borderRadius: BorderRadius.circular(35.h),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(moneyRegexp)],
        cursorColor: Themes.primaryColor,
        maxLines: 1,
        decoration: InputDecoration(hintText: label, border: InputBorder.none),
        style: TextStyle(fontSize: 28.sp),
      ),
    );
  }
}
