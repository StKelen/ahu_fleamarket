import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/widgets/list/list.dart';

import 'appbar.dart';
import 'drawer.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool desc = true;
  String keywords = '';
  String order = 'time';
  int cid = 0;
  int bid = 0;
  double minPrice;
  double maxPrice;
  String url = '';

  getKeywords(String value) {
    if (value == '') return;
    setState(() => {keywords = value});
    urlHandler();
  }

  Function handleOrderClick(String o) => () {
        if (o == order) {
          setState(() => {desc = !desc});
        } else {
          setState(() {
            order = o;
            desc = true;
          });
        }
        urlHandler();
      };

  void handleDrawer() => _scaffoldKey.currentState.openEndDrawer();

  void getFilterInfo(int bid, int cid, double minPrice, double maxPrice) {
    this.cid = cid;
    this.bid = bid;
    this.minPrice = minPrice;
    this.maxPrice = maxPrice;
    Navigator.pop(context);
    urlHandler();
  }

  IconData getIcon(String o) {
    if (o != order) return Icons.unfold_more;
    if (desc) return Icons.expand_more;
    return Icons.expand_less;
  }

  void urlHandler() {
    var newUrl = '${ServiceUrl.listUrl}?';
    newUrl += 'search=$keywords&';
    newUrl += 'order=${desc ? 'desc' : 'asc'}&';
    newUrl += 'by=$order&';
    if (cid != 0) newUrl += 'cid=$cid&';
    if (bid != 0) newUrl += 'bid=$bid&';
    if (minPrice != null && minPrice > 0) newUrl += 'minPrice=${minPrice.toStringAsFixed(2)}&';
    if (maxPrice != null && maxPrice > 0) newUrl += 'maxPrice=${maxPrice.toStringAsFixed(2)}&';
    setState(() {
      url = newUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Themes.pageBackgroundColor,
      appBar: getAppbar(context, keywords, getKeywords),
      body: url == ''
          ? null
          : Stack(
              children: [
                Positioned(
                  top: 0,
                  width: size.width,
                  child: Container(
                    height: 60.h,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: FlatButton(
                                textColor: order == 'time'
                                    ? Themes.textPrimaryColor
                                    : Themes.textSecondaryColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '时间',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                    Icon(getIcon('time'))
                                  ],
                                ),
                                onPressed: handleOrderClick('time'))),
                        Expanded(
                            flex: 1,
                            child: FlatButton(
                                textColor: order == 'price'
                                    ? Themes.textPrimaryColor
                                    : Themes.textSecondaryColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '价格',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                    Icon(getIcon('price'))
                                  ],
                                ),
                                onPressed: handleOrderClick('price'))),
                        Expanded(
                            flex: 1,
                            child: FlatButton(
                                textColor: Themes.textSecondaryColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '筛选',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                    Icon(Icons.menu_open)
                                  ],
                                ),
                                onPressed: handleDrawer)),
                      ],
                    ),
                  ),
                ),
                Container(margin: EdgeInsets.only(top: 60.h), child: DetailList(url))
              ],
            ),
      endDrawer: SearchDrawer(
        getFilterInfo: getFilterInfo,
      ),
    );
  }
}
