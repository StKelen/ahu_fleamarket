import 'dart:io';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flea_market/requests/index.dart';
import 'package:flea_market/common/categories.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/config/service_url.dart';

import 'package:flea_market/widgets/select_image/select_image.dart';
import 'package:flea_market/widgets/primary_button/primary_button.dart';
import 'package:flea_market/widgets/row_button/row_button.dart';
import 'package:flea_market/widgets/category_dropdown/category_dropdown.dart';

import 'price_form.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final _descController = TextEditingController();

  Map<String, File> images = {};
  Widget categoryTail;
  int cid = 0;
  double price = 0.00;
  double buyPrice = 0.00;

  imageHandler(File image) {
    var imageMD5 = md5.convert(image.readAsBytesSync()).toString();
    if (images.containsKey(imageMD5)) return null;
    setState(() {
      images[imageMD5] = image;
    });
  }

  Function addImage(context) => selectImage(context, imageHandler);

  Widget imageGridView() {
    return Builder(
      builder: (ctx) {
        return GridView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: images.length + 1,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            var content;
            if (index == images.length) {
              content = FlatButton(
                highlightColor: Color(0x00FFFFFF),
                onPressed: addImage(ctx),
                child: Icon(
                  Icons.add,
                  size: 80,
                  color: Themes.primaryColor,
                ),
              );
            } else {
              content = ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.file(
                  (images.values.toList())[index],
                  fit: BoxFit.cover,
                ),
              );
            }
            return Container(
              child: content,
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Themes.secondaryColor),
            );
          },
        );
      },
    );
  }

  void onChangeCategory(value) {
    setState(() {
      cid = value['cid'];
      categoryTail = Row(
        children: [category(value['icon'], 22), Text(value['name'])],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      );
    });
  }

  void onPressPrice() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets, //边距（必要）
            duration: const Duration(milliseconds: 100), //时常 （必要）
            child: PriceForm(price: getPrice),
          );
        });
  }

  void getPrice(double price, double buyPrice) {
    setState(() {
      this.price = price;
      this.buyPrice = buyPrice;
    });
    Navigator.pop(context);
  }

  void onPublish() async {
    if (price.toStringAsFixed(2) == '0.00') {
      Fluttertoast.showToast(msg: '请不要白给');
      return;
    }

    var data = {
      "desc": _descController.text,
      "cid": cid,
      "price": price,
      "buy_price": buyPrice,
      "images": images.keys.map((key) {
        return MultipartFile.fromFileSync(images[key].path);
      }).toList()
    };
    var form = FormData.fromMap(data);
    await MyDio.post(ServiceUrl.detailUrl, form, (res) {}, (e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Themes.primaryColor,
          splashColor: Color(0x00FFFFFF),
          highlightColor: Color(0x00FFFFFF),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '发布闲置物品',
          style: TextStyle(color: Themes.textPrimaryColor),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
              child: PrimaryButton(
                text: '发布',
                onPressed: onPublish,
                fontSize: 16,
                minWidth: 40,
              )),
        ],
        centerTitle: true,
        backgroundColor: Color(0x00FFFFFF),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _descController,
              autofocus: false,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                  hintText: '说说你的使用感受、购买渠道和转手原因吧~',
                  hintStyle: TextStyle(
                    color: Themes.textSecondaryColor,
                  ),
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
              maxLines: 5,
              cursorColor: Themes.primaryColor,
            ),
            imageGridView(),
            CategoryDropdown(
              leadingText: '分类',
              leadingIcon: Icons.category,
              tail: categoryTail,
              onChanged: onChangeCategory,
            ),
            RowButton(
                leadingText: '价格',
                leadingIcon: Icons.attach_money,
                onPressed: onPressPrice,
                tailText: '¥${price.toStringAsFixed(2)}')
          ],
        ),
      ),
      backgroundColor: Themes.pageBackgroundColor,
    );
  }
}
