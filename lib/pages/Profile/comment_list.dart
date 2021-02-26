import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/widgets/single_row_list/single_row_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentList extends StatelessWidget {
  final int uid;

  CommentList(this.uid, {Key key}) : super(key: key);

  Widget _commentItemBuilder(data, refresh) {
    print(data);
    return Container(
      margin: EdgeInsets.fromLTRB(50.w, 1.h, 50.w, 60.h),
      padding: EdgeInsets.only(top: 40.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Themes.textSecondaryColor, width: 1.0.h),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('${ServiceUrl.uploadImageUrl}/${data['avatar']}'),
                radius: 45.r,
              ),
              SizedBox(width: 30.w),
              Text(
                data['nickname'],
                style: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 100.r, top: 20.h),
            child: Text(
              '${data['comment']}',
              style: TextStyle(fontSize: 38.sp),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleRowList('${ServiceUrl.commentUrl}?uid=$uid&', _commentItemBuilder);
  }
}
