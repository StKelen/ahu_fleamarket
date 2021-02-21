import 'package:flutter/material.dart';
import 'package:frefresh/frefresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/images.dart';
import 'package:flea_market/requests/index.dart';

import 'list_item.dart';

class DetailList extends StatefulWidget {
  final String url;
  final Widget widgetBefore;

  DetailList(this.url, {this.widgetBefore, Key key}) : super(key: key);

  @override
  _DetailListState createState() => _DetailListState();
}

class _DetailListState extends State<DetailList> {
  final FRefreshController _controller = FRefreshController();

  var _list = [];
  var _page = 1;
  var _isLoading = false;
  var _loadedAll = false;

  Future _getList() async {
    if (_isLoading || _loadedAll) {
      return;
    }
    _isLoading = true;
    await MyDio.get('${widget.url}page=$_page', (res) {
      if (res['data'] == null) {
        setState(() {
          _isLoading = false;
          _loadedAll = true;
          if (_page == 1) {
            _list = [];
          }
        });
        return;
      }
      setState(() {
        if (_page == 1) {
          _list = res['data'];
        } else {
          _list.addAll(res['data']);
        }
        _page++;
        _isLoading = false;
      });
    }, (e) {
      Fluttertoast.showToast(msg: e);
    });
  }

  void _refresh() async {
    _page = 1;
    _isLoading = false;
    _loadedAll = false;
    await _getList();
    _controller.finishRefresh();
  }

  void _loadMore() async {
    if (!_loadedAll) await _getList();
    _controller.finishLoad();
  }

  @override
  void initState() {
    _getList();
    super.initState();
  }

  @override
  void didUpdateWidget(DetailList old) {
    if (old.url != widget.url) {
      _refresh();
    }
    super.didUpdateWidget(old);
  }

  @override
  Widget build(BuildContext context) {
    return FRefresh(
      controller: _controller,
      header: Center(
        child: Image.asset(
          Images.loading,
          fit: BoxFit.contain,
          height: 50.h,
          width: 50.h,
        ),
      ),
      headerHeight: 80.h,
      child: Column(
        children: [
          widget.widgetBefore ?? Container(),
          WaterfallFlow.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 10, bottom: 40, left: 10, right: 10),
            gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.w,
              mainAxisSpacing: 20.h,
            ),
            itemCount: _list.length,
            itemBuilder: (ctx, i) {
              return ListItem(
                  _list[i]['did'],
                  _list[i]['cover'],
                  _list[i]['title'],
                  _list[i]['price'],
                  _list[i]['avatar'],
                  _list[i]['nickname'],
                  _list[i]['building']);
            },
          ),
        ],
      ),
      footer: Center(
        child: _loadedAll
            ? Text(
                '—   我也是有底线的   —',
                style: TextStyle(color: Themes.textSecondaryColor, fontSize: 26.sp),
              )
            : Image.asset(
                Images.loading,
                fit: BoxFit.contain,
                height: 50.h,
                width: 50.h,
              ),
      ),
      footerHeight: 80.h,
      onRefresh: _refresh,
      onLoad: _loadMore,
    );
  }
}
