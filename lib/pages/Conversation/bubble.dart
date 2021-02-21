import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flea_market/widgets/full_screen_image/full_screen_image.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:fsuper/fsuper.dart';

class Bubble extends StatelessWidget {
  final ChatMessage message;
  final DateFormat timeFormat = DateFormat("HH:mm");

  /// A flag which is used for assiging styles
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
    final size = MediaQuery.of(context).size;
    final constraints = BoxConstraints(
      maxHeight: size.height,
      maxWidth: size.width,
    );
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: constraints.maxWidth * 0.8,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        width: constraints.maxWidth * 0.7,
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
    padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
    backgroundColor: isUser ? Color(0xffa5ed7e) : Colors.white,
    corner: FCorner.all(6),
    text: text,
    style: TextStyle(fontSize: 18),
    child1: Transform.rotate(
      angle: 90,
      child: FSuper(
        width: 20,
        height: 20,
        backgroundColor: isUser ? Color(0xffa5ed7e) : Colors.white,
        corner: FCorner.all(1.5),
      ),
    ),
    child1Alignment: isUser ? Alignment.topRight : Alignment.topLeft,
    child1Margin: isUser ? EdgeInsets.only(right: -4, top: 20) : EdgeInsets.only(left: -4, top: 20),
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
          var width = constraints.maxWidth * 0.6;
          var scale = width / data.width;
          var height = data.height * scale;
          return FSuper(
            width: width,
            height: height,
            padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
            backgroundColor: isUser ? Color(0xffa5ed7e) : Colors.white,
            corner: FCorner.all(6),
            child1: Transform.rotate(
              angle: 90,
              child: FSuper(
                width: 20,
                height: 20,
                backgroundColor: isUser ? Color(0xffa5ed7e) : Colors.white,
                corner: FCorner.all(1.5),
              ),
            ),
            child1Alignment: isUser ? Alignment.topRight : Alignment.topLeft,
            child1Margin:
                isUser ? EdgeInsets.only(right: -4, top: 20) : EdgeInsets.only(left: -4, top: 20),
            shadowColor: isUser ? Color(0xffa5ed7e) : Colors.white,
            shadowBlur: 3,
            child2: FullScreenWidget(
                backgroundColor: Colors.black12,
                child: Hero(
                    tag: '$imagePath${image.hashCode}',
                    child: Image(
                      width: width - 20,
                      height: height - 20,
                      image: image,
                    ))),
            child2Alignment: Alignment.center,
          );
        }
        return Container();
      });
}
