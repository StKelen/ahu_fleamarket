import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/pages/Profile/comment_list.dart';
import 'package:flea_market/widgets/list/list.dart';
import 'user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends StatefulWidget {
  final int uid;
  Profile(this.uid, {Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    _controller = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人主页', style: TextStyle(color: Colors.white)),
        backgroundColor: Themes.accentColor,
        iconTheme: IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: Size(750.w, 300.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              UserInfo(uid: widget.uid),
              Container(
                color: Themes.pageBackgroundColor,
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 150.w),
                child: TabBar(
                  controller: _controller,
                  labelStyle: TextStyle(fontSize: 32.sp),
                  labelColor: Themes.textPrimaryColor,
                  labelPadding: EdgeInsets.symmetric(vertical: 15.h),
                  indicatorColor: Themes.primaryColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 5.h,
                  tabs: [Tab(text: 'TA发布的'), Tab(text: '对TA的评价')],
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          DetailList('${ServiceUrl.listUrl}?uid=${widget.uid}&'),
          CommentList(widget.uid),
        ],
      ),
    );
  }
}
