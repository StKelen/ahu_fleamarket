import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/widgets/form_input/form_input.dart';
import 'package:flea_market/widgets/primary_button/primary_button.dart';

class PriceForm extends StatelessWidget {
  final Function price;

  PriceForm({this.price, Key key}) : super(key: key);

  final moneyRegexp = RegExp(r'^(0|[1-9][0-9]*)\.?[0-9]{0,2}$');

  final _priceController = TextEditingController();
  final _buyPriceController = TextEditingController();

  void getPrice() {
    var priceText = _priceController.text;
    if (!moneyRegexp.hasMatch(priceText)) {
      EasyLoading.showError('价格格式错误');
      return;
    }
    var buyPriceText = _buyPriceController.text;
    if (!moneyRegexp.hasMatch(buyPriceText)) {
      EasyLoading.showError('入手价格式错误');
      return;
    }
    var price = double.parse(priceText);
    var buyPrice = double.parse(buyPriceText);
    this.price(price, buyPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 30.h),
      child: Form(
        autovalidateMode: AutovalidateMode.disabled,
        child: ListView(
          shrinkWrap: true,
          children: [
            FormInput(
              controller: _priceController,
              labelText: '价格',
              prefixText: '¥',
              hintText: '0.00',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(moneyRegexp)],
            ),
            FormInput(
              controller: _buyPriceController,
              labelText: '入手价',
              prefixText: '¥',
              hintText: '0.00',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(moneyRegexp)],
            ),
            SizedBox(height: 20.h),
            PrimaryButton(
              text: '确认',
              onPressed: getPrice,
            )
          ],
        ),
      ),
    );
  }
}
