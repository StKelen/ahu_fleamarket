import 'package:flutter/material.dart';
import 'package:frefresh/frefresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/images.dart';
import 'package:flea_market/requests/index.dart';

class SingleRowList extends StatefulWidget {
  final String url;
  final Widget Function(Map<String, dynamic> data, Function refresh) itemBuilder;
  SingleRowList(this.url, this.itemBuilder, {Key key}) : super(key: key);

  @override
  _SingleRowListState createState() => _SingleRowListState();
}

class _SingleRowListState extends State<SingleRowList> {
  final FRefreshController _controller = FRefreshController();

  var _list = [];
  var _page = 1;
  var isLoading = false;
  var loadedAll = false;

  Future _getList() async {
    if (isLoading || loadedAll) {
      return;
    }
    isLoading = true;
    await MyDio.get(
      '${widget.url}page=$_page',
      (res) {
        if (res['data'] == null) {
          setState(() {
            isLoading = false;
            loadedAll = true;
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
          isLoading = false;
        });
      },
      (e) {
        EasyLoading.showError(e);
      },
    );
  }

  void _refresh() async {
    _page = 1;
    isLoading = false;
    loadedAll = false;
    await _getList();
    _controller.finishRefresh();
  }

  void _loadMore() async {
    if (!loadedAll) await _getList();
    _controller.finishLoad();
  }

  @override
  void initState() {
    _getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FRefresh(
      header: Center(
        child: Image.asset(
          Images.loading,
          fit: BoxFit.contain,
          height: 100.w,
          width: 100.w,
        ),
      ),
      headerHeight: 120.w,
      controller: _controller,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _list.length,
        itemBuilder: (ctx, i) {
          return widget.itemBuilder(_list[i], _refresh);
        },
      ),
      footer: Center(
        child: loadedAll
            ? Text(
                '—   我也是有底线的   —',
                style: TextStyle(color: Themes.textSecondaryColor, fontSize: 18),
              )
            : Image.asset(
                Images.loading,
                fit: BoxFit.contain,
                height: 100.w,
                width: 100.w,
              ),
      ),
      footerHeight: 120.w,
      onRefresh: _refresh,
      onLoad: _loadMore,
    );
  }
}
