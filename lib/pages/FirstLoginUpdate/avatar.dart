import 'package:flutter/material.dart';

import 'package:flea_market/common/config/theme.dart';

class Avatar extends StatelessWidget {
  final ImageProvider image;
  final Function onTap;
  Avatar({this.image, this.onTap, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            style: BorderStyle.solid,
            color: Themes.primaryColor,
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.face,
                color: Themes.primaryColor,
              ),
              SizedBox(width: 10),
              Text(
                '头像',
                style: TextStyle(color: Themes.textPrimaryColor, fontSize: 18),
              )
            ],
          ),
          Container(
            width: 80,
            height: 80,
            // color: Color(0xFFFFFFFF),
            child: InkWell(
              child: CircleAvatar(
                  backgroundImage:
                      ResizeImage.resizeIfNeeded(null, null, image)),
              onTap: onTap,
              borderRadius: BorderRadius.circular(40),
            ),
          )
        ],
      ),
    );
  }
}
