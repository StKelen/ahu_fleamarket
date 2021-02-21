import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/categories.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/requests/index.dart';

class CategoryDropdown extends StatefulWidget {
  final String leadingText;
  final IconData leadingIcon;
  final Widget tail;
  final Function onChanged;

  CategoryDropdown({this.leadingText, this.leadingIcon, this.tail, this.onChanged, Key key})
      : super(key: key);

  @override
  _CategoryDropdownState createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  getCategories() => _memoizer.runOnce(() async {
        var data;
        await MyDio.get(ServiceUrl.categoryUrl, (res) {
          data = res;
        }, (e) {
          Fluttertoast.showToast(msg: '获取分类信息失败');
        });
        return data;
      });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      child: FutureBuilder(
        future: getCategories(),
        builder: (context, snapshot) {
          var items;
          if (snapshot.data == null || snapshot.data['data'] == null) {
            items = null;
          } else {
            var list = snapshot.data['data'] as List;
            items = list.map((element) {
              return DropdownMenuItem(
                child: Container(
                  width: size.width,
                  child: Row(
                    children: [
                      category(element['icon'], 50.sp),
                      SizedBox(width: 15.w),
                      Text(
                        element['name'],
                        style: TextStyle(fontSize: 32.sp, color: Themes.textPrimaryColor),
                      )
                    ],
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
                value: element,
              );
            }).toList();
          }
          return Padding(
            padding: EdgeInsetsDirectional.only(start: 16.w, end: 12.w),
            child: Row(
              children: [
                Container(
                  child: Icon(
                    widget.leadingIcon,
                    size: 38.sp,
                    color: Themes.primaryColor,
                  ),
                  width: 60.r,
                  height: 60.r,
                  decoration: BoxDecoration(
                      color: Themes.secondaryColor, borderRadius: BorderRadius.circular(30.r)),
                  margin: EdgeInsets.fromLTRB(0, 0, 10.w, 0),
                ),
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    items: items,
                    onChanged: widget.onChanged,
                    icon: Row(
                      children: [widget.tail ?? Text(''), Icon(Icons.arrow_drop_down)],
                    ),
                    hint: Text(
                      widget.leadingText,
                      style: TextStyle(
                          fontSize: 30.sp,
                          color: Themes.textPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    underline: Container(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
