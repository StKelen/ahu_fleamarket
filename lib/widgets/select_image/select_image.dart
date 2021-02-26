import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/theme.dart';

selectImage(context, imageHandler) {
  Function sourceHandler(ImageSource source, BuildContext ctx) {
    return () async {
      PickedFile pickedImage = await ImagePicker().getImage(source: source);
      File image = File(pickedImage.path);
      imageHandler(image);
      Navigator.pop(ctx);
    };
  }

  return () => showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Padding(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 750.w,
                    child: FlatButton(
                      child: Text(
                        '从相册选择',
                        style: TextStyle(fontSize: 18, color: Themes.textPrimaryColor),
                      ),
                      onPressed: sourceHandler(ImageSource.gallery, context),
                    ),
                  ),
                  SizedBox(
                    width: 750.w,
                    child: FlatButton(
                      child: Text(
                        '拍照',
                        style: TextStyle(fontSize: 18, color: Themes.textPrimaryColor),
                      ),
                      onPressed: sourceHandler(ImageSource.camera, context),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
}
