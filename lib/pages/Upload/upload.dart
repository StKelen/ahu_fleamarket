import 'package:flutter/material.dart';

import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/common/categories.dart';

import 'package:flea_market/widgets/primary_button/primary_button.dart';
import 'package:flea_market/widgets/row_button/row_button.dart';
import 'category_dropdown.dart';
import 'price_form.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  List<String> imageUrls = [];
  Widget categoryTail;
  int cid = 0;
  double price = 0.00;
  double buyPrice = 0.00;

  Widget imageGridView() {
    return Builder(
      builder: (ctx) {
        return GridView.count(
          crossAxisCount: 3,
          children: List.generate(imageUrls.length + 1, (index) {
            var content;
            if (index == imageUrls.length) {
              content = GestureDetector(
                child: Icon(
                  Icons.add,
                  size: 80,
                  color: Themes.primaryColor,
                ),
              );
            } else {
              content = Icon(
                Icons.add,
                size: 50,
              );
            }
            return Container(
              child: content,
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Themes.secondaryColor),
            );
          }),
          shrinkWrap: true,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
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
          return PriceForm(price: getPrice);
        });
  }

  void getPrice(double price, double buyPrice) {
    setState(() {
      this.price = price;
      this.buyPrice = buyPrice;
    });
    Navigator.pop(context);
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
                onPressed: () {},
                fontSize: 16,
                minWidth: 40,
              )),
        ],
        centerTitle: true,
        backgroundColor: Color(0x00FFFFFF),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            TextField(
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
