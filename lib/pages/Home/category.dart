import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/common/categories.dart';
import 'package:flea_market/requests/index.dart';
import 'package:flea_market/widgets/icon_button/icon_button.dart';

class Category extends StatelessWidget {
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
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [BoxShadow(offset: Offset(2, 3), color: Color(0x44B2AEC1), blurRadius: 5)]),
      child: FutureBuilder(
        future: getCategories(),
        builder: (ctx, snapshot) {
          if (snapshot.data == null)
            return Center(
                child: Text(
              '正在加载',
              style: TextStyle(color: Themes.textPrimaryColor, fontSize: 20.sp),
            ));
          var data = snapshot.data['data'] as List;
          return GridView.count(
              shrinkWrap: true,
              crossAxisCount: 5,
              children: data.map((element) {
                return IconListButton(
                    category(element['icon'], 70.sp), element['name'], element['cid']);
              }).toList());
        },
      ),
    );
  }
}
