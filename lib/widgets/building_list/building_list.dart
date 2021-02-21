import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/requests/index.dart';

class BuildingListFormField extends StatelessWidget {
  final Function onChanged;
  final Function validator;
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  BuildingListFormField({this.onChanged, this.validator, Key key}) : super(key: key);

  getBuildingList() => _memoizer.runOnce(() async {
        var data;
        await MyDio.get(ServiceUrl.buildingListUrl, (res) {
          data = res;
        }, (e) {
          Fluttertoast.showToast(msg: '获取楼栋信息失败');
        });
        return data;
      });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.all(20.w),
      width: size.width * 0.9,
      child: FutureBuilder(
        future: getBuildingList(),
        builder: (context, snapshot) {
          var items;
          if (snapshot.data == null || snapshot.data['data'] == null) {
            items = null;
          } else {
            var list = snapshot.data['data'] as List;
            items = list.map((element) {
              return DropdownMenuItem(
                child: Text(
                  element['name'],
                  style: TextStyle(fontSize: 32.sp),
                ),
                value: element['bid'],
              );
            }).toList();
          }
          return DropdownButtonFormField(
            items: items,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.list, size: 50.sp, color: Themes.primaryColor),
              labelText: '公寓楼栋',
              labelStyle: TextStyle(fontSize: 32.sp),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Themes.primaryColor, width: 2)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(size.height / 2),
                  borderSide: BorderSide(color: Themes.primaryColor, width: 2)),
            ),
            onChanged: onChanged,
            validator: validator,
          );
        },
      ),
    );
  }
}
