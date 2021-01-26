import 'package:flutter/material.dart';
import 'package:flea_market/requests/index.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/widgets/list/list_item.dart';

class DetailList extends StatefulWidget {
  final String url;
  final ScrollController controller;
  DetailList(this.controller, this.url, {Key key}) : super(key: key);
  @override
  _DetailListState createState() => _DetailListState();
}

class _DetailListState extends State<DetailList> {
  var _list = [];
  var page = 1;
  var isLoading = false;
  var loadedAll = false;

  @override
  void initState() {
    var _scrollController = widget.controller;
    _scrollController.addListener(() {
      var px = _scrollController.position.pixels;
      var max = _scrollController.position.maxScrollExtent;
      if (px == max) {
        _getList();
      }
    });
    _getList();
    super.initState();
  }

  @override
  void didUpdateWidget(DetailList old) {
    super.didUpdateWidget(old);
    if (old.url != widget.url) {
      setState(() {
        page = 1;
        loadedAll = false;
      });
      widget.controller.jumpTo(0);
      _getList();
    }
  }

  _getList() async {
    if (isLoading || loadedAll) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    await MyDio.get('${widget.url}page=$page', (res) {
      if (res['data'] == null) {
        setState(() {
          isLoading = false;
          loadedAll = true;
          if (page == 1) {
            _list = [];
          }
        });
        return;
      }
      setState(() {
        if (page == 1) {
          _list = res['data'];
        } else {
          _list.addAll(res['data']);
        }
        page++;
        isLoading = false;
      });
    }, (e) {
      Fluttertoast.showToast(msg: e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      primary: false,
      children: [
        StaggeredGridView.countBuilder(
          padding: EdgeInsets.all(8),
          crossAxisCount: 2,
          shrinkWrap: true,
          primary: false,
          itemCount: _list.length,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
          staggeredTileBuilder: (i) => StaggeredTile.fit(1),
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
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 40),
          child: Column(
            children: [
              Offstage(
                offstage: !isLoading,
                child: Text(
                  '—   加载中   —',
                  style:
                      TextStyle(color: Themes.textSecondaryColor, fontSize: 18),
                ),
              ),
              Offstage(
                offstage: !loadedAll,
                child: Text(
                  '—   我也是有底线的   —',
                  style:
                      TextStyle(color: Themes.textSecondaryColor, fontSize: 18),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
