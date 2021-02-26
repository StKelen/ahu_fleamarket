import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fsuper/fsuper.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/widgets/full_screen_image/full_screen_image.dart';

class Bubble extends StatelessWidget {
  final ChatMessage message;
  final DateFormat timeFormat = DateFormat("HH:mm");
  final bool isUser;

  final List<Widget> buttons;
  final List<Widget> Function(ChatMessage) messageButtonsBuilder;

  Bubble({
    @required this.message,
    this.isUser,
    this.messageButtonsBuilder,
    this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    final constraints = BoxConstraints(
      maxHeight: 1334.h,
      maxWidth: 750.w,
    );
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 550.w,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        child: Align(
          alignment: isUser ? Alignment.topRight : Alignment.topLeft,
          child: message.image == null
              ? _textHandler(message.text, constraints, isUser)
              : _imageHandler(context, message.image, constraints, isUser),
        ),
      ),
    );
  }
}

Widget _textHandler(String text, BoxConstraints constraints, bool isUser) {
  return FSuper(
    padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h, bottom: 15.h),
    backgroundColor: isUser ? Color(0xffa5ed7e) : Colors.white,
    corner: FCorner.all(10.r),
    text: text,
    style: TextStyle(fontSize: 30.sp),
    child1: Transform.rotate(
      angle: pi / 4,
      child: FSuper(
        width: 30.w,
        height: 30.w,
        backgroundColor: isUser ? Color(0xffa5ed7e) : Colors.white,
        corner: FCorner.all(1.r),
      ),
    ),
    child1Alignment: isUser ? Alignment.topRight : Alignment.topLeft,
    child1Margin:
        isUser ? EdgeInsets.only(right: -10.w, top: 30.h) : EdgeInsets.only(left: -10.w, top: 30.h),
    shadowColor: isUser ? Color(0xffa5ed7e) : Colors.white,
    shadowBlur: 3,
  );
}

Widget _imageHandler(BuildContext ctx, String imagePath, BoxConstraints constraints, bool isUser) {
  final image = FileImage(File(imagePath));
  final ImageConfiguration config = createLocalImageConfiguration(ctx);
  final Completer<ui.Image> completer = Completer<ui.Image>();
  final ImageStream stream = image.resolve(config);
  var listener;
  listener = ImageStreamListener(
    (ImageInfo image, bool sync) {
      completer.complete(image.image);
      stream.removeListener(listener);
    },
    onError: (dynamic exception, StackTrace stackTrace) {
      completer.complete();
      stream.removeListener(listener);
    },
  );
  stream.addListener(listener);
  return FutureBuilder(
      future: completer.future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          var width = 400.w;
          var scale = width / data.width;
          var height = data.height * scale;
          return FSuper(
            width: width,
            height: height,
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h, bottom: 15.h),
            backgroundColor: isUser ? Color(0xffa5ed7e) : Colors.white,
            corner: FCorner.all(6),
            child1: Transform.rotate(
              angle: pi / 4,
              child: FSuper(
                width: 30.w,
                height: 30.w,
                backgroundColor: isUser ? Color(0xffa5ed7e) : Colors.white,
                corner: FCorner.all(1.r),
              ),
            ),
            child1Alignment: isUser ? Alignment.topRight : Alignment.topLeft,
            child1Margin: isUser
                ? EdgeInsets.only(right: -10.w, top: 30.h)
                : EdgeInsets.only(left: -10.w, top: 30.h),
            shadowColor: isUser ? Color(0xffa5ed7e) : Colors.white,
            shadowBlur: 3,
            child2: FullScreenWidget(
                backgroundColor: Colors.black12,
                child: Hero(
                    tag: '$imagePath${image.hashCode}',
                    child: Image(
                      width: width - 20.w,
                      height: height - 15.h,
                      image: image,
                    ))),
            child2Alignment: Alignment.center,
          );
        }
        return Container();
      });
}
