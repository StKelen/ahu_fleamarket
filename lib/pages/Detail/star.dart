import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/requests/index.dart';

class Star extends StatefulWidget {
  final int did;
  Star(this.did, {Key key}) : super(key: key);
  @override
  _StarState createState() => _StarState();
}

class _StarState extends State<Star> {
  var isStared = false;
  var throttle = false;
  final throttleTime = Duration(milliseconds: 500);

  init() async {
    await MyDio.get(ServiceUrl.starUrl + '?did=${widget.did}', (res) {
      var stared = res['data']['is_stared'];
      if (stared != null) {
        setState(() {
          isStared = stared;
        });
      }
    }, (e) {});
  }

  onStar() async {
    if (throttle) return;
    throttle = true;
    await MyDio.put(ServiceUrl.starUrl + '?did=${widget.did}', resolve: (res) {
      setState(() {
        isStared = !isStared;
      });
      Timer(throttleTime, () {
        throttle = false;
      });
    }, reject: (e) {
      throttle = false;
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        isStared ? Icons.favorite : Icons.favorite_border,
        size: 70.sp,
      ),
      color: isStared ? Colors.red : Colors.redAccent,
      onPressed: onStar,
    );
  }
}
