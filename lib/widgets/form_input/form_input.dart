import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/config/theme.dart';

class FormInput extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final String prefixText;
  final String hintText;
  final bool isPassword;
  final bool enabled;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final TextEditingController controller;
  final Function validator;

  const FormInput(
      {Key key,
      this.icon,
      this.labelText,
      this.prefixText,
      this.hintText,
      this.isPassword = false,
      this.keyboardType,
      this.inputFormatters,
      this.enabled = true,
      this.controller,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      width: 0.9 * 750.w,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        enabled: enabled,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Themes.primaryColor, size: 50.sp),
          prefixText: prefixText,
          labelText: labelText,
          hintText: hintText,
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Themes.primaryColor, width: 2)),
          focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(3.h),
              borderSide: BorderSide(color: Themes.primaryColor, width: 2)),
        ),
        style: TextStyle(
            fontSize: 30.sp, color: enabled ? Themes.textPrimaryColor : Themes.textSecondaryColor),
        validator: validator,
      ),
    );
  }
}
