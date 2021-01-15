import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flea_market/widgets/form_input/form_input.dart';
import 'package:flea_market/widgets/primary_button/primary_button.dart';

class PriceForm extends StatelessWidget {
  final Function price;

  PriceForm({this.price, Key key}) : super(key: key);

  final moneyRegexp = RegExp(r'^(0|[1-9][0-9]*).?[0-9]{0,2}$');

  final _priceController = TextEditingController();
  final _buyPriceController = TextEditingController();

  void getPrice() {
    var priceText = _priceController.text;
    if (!moneyRegexp.hasMatch(priceText)) {
      Fluttertoast.showToast(msg: '价格格式错误');
      return;
    }
    var buyPriceText = _buyPriceController.text;
    if (!moneyRegexp.hasMatch(buyPriceText)) {
      Fluttertoast.showToast(msg: '入手价格式错误');
      return;
    }
    var price = double.parse(priceText);
    var buyPrice = double.parse(buyPriceText);
    this.price(price, buyPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
      child: Form(
        autovalidateMode: AutovalidateMode.disabled,
        child: ListView(
          shrinkWrap: false,
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
