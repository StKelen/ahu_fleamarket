import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/theme.dart';

class BottomBarDecoration extends StatefulWidget {
  final int prevIndex;
  final int currentIndex;
  final int itemsCount;

  BottomBarDecoration(this.prevIndex, this.currentIndex, this.itemsCount, {Key key})
      : super(key: key);

  @override
  _BottomBarDecorationState createState() => _BottomBarDecorationState();
}

class _BottomBarDecorationState extends State<BottomBarDecoration>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  double screenWidth = 0;

  double get prevDecorationLeftWidth =>
      screenWidth / (widget.itemsCount * 2) * (widget.prevIndex * 2 + 1);

  double get currentDecorationLeftWidth =>
      screenWidth / (widget.itemsCount * 2) * (widget.currentIndex * 2 + 1);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BottomBarDecoration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.prevIndex == widget.currentIndex) return;
    controller.reset();
    animation = Tween<double>(begin: prevDecorationLeftWidth, end: currentDecorationLeftWidth)
        .animate(controller)
          ..addListener(() => setState(() {}));
    controller.forward();
  }

  bool calculateIsPlaying() {
    if (animation == null) return false;
    if ((animation.value < prevDecorationLeftWidth + 80.r) &&
        (animation.value > prevDecorationLeftWidth - 80.r)) return false;
    if ((animation.value < currentDecorationLeftWidth + 80.r) &&
        (animation.value > currentDecorationLeftWidth - 80.r)) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      left: (animation == null ? prevDecorationLeftWidth : animation.value) - 40.r,
      child: AnimatedContainer(
        width: calculateIsPlaying() ? 10.r : 80.r,
        height: calculateIsPlaying() ? 10.r : 80.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.r),
          color: calculateIsPlaying() ? Themes.primaryColor : Themes.secondaryColor,
        ),
        duration: Duration(milliseconds: 60),
      ),
    );
  }
}
