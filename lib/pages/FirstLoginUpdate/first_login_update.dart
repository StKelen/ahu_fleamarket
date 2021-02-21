import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flea_market/common/code/code.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/common/images.dart';
import 'package:flea_market/common/im/im.dart';
import 'package:flea_market/requests/index.dart';
import 'package:flea_market/provider/global.dart';

import 'package:flea_market/widgets/select_image/select_image.dart';
import 'package:flea_market/widgets/building_list/building_list.dart';
import 'package:flea_market/widgets/primary_button/primary_button.dart';
import 'package:flea_market/widgets/form_input/form_input.dart';

import 'avatar.dart';

class FirstLoginUpdate extends StatefulWidget {
  final String sid;
  final String name;
  final String sex;
  final String mobile;

  FirstLoginUpdate({this.sid, this.name, this.sex, this.mobile, Key key}) : super(key: key);

  @override
  _FirstLoginUpdateState createState() => _FirstLoginUpdateState();
}

class _FirstLoginUpdateState extends State<FirstLoginUpdate> {
  GlobalKey _formKey = GlobalKey<FormState>();

  final mobileRegExp = RegExp(r'^1[3-9]\d{9}$');

  final _sidController = TextEditingController();
  final _nameController = TextEditingController();
  final _sexController = TextEditingController();
  final _mobileController = TextEditingController();
  final _nicknameController = TextEditingController();
  int _building = 0;
  File image;
  ImageProvider avatarImage = ExactAssetImage(Images.avatar);

  @override
  void initState() {
    rootBundle.load(Images.avatar);
    _sidController.text = widget.sid;
    _nameController.text = widget.name;
    _sexController.text = widget.sex;
    _mobileController.text = widget.mobile;
    super.initState();
  }

  void onChangeBuilding(value) {
    assert(value.runtimeType == int);
    _building = value;
  }

  void onUpdateInfo() async {
    var formState = _formKey.currentState as FormState;
    if (formState.validate()) {
      var sid = _sidController.value.text;
      var name = _nameController.value.text;
      var sex = _sexController.value.text;
      var mobile = _mobileController.value.text;
      var nickname = _nicknameController.value.text;
      var data = {
        "sid": sid,
        "name": name,
        "sex": sex,
        "mobile": mobile,
        "nickname": nickname,
        "bid": _building
      };
      if (image != null) {
        data["avatar"] = await MultipartFile.fromFile(image.path);
      }
      await MyDio.post(ServiceUrl.firstLoginUpdateUrl, FormData.fromMap(data), (res) async {
        int code = res['code'];
        if (code != Code.Success) {
          Fluttertoast.showToast(msg: res['msg']);
          return;
        }
        int uid = res['data']['uid'];
        await IM.register(uid, sid, nickname, image?.path ?? null);
        Fluttertoast.showToast(msg: '注册成功', backgroundColor: Colors.black);
        GlobalModel.setUserInfo(uid, sid);
        Navigator.popUntil(context, (route) => route.isFirst);
      }, (e) {
        Fluttertoast.showToast(msg: e);
      });
    } else {
      Fluttertoast.showToast(msg: '请完善相关信息');
    }
  }

  void onGetImage(File image) {
    setState(() {
      this.image = image;
      avatarImage = FileImage(image);
    });
  }

  Function onTapAvatar(context) {
    return selectImage(context, onGetImage);
  }

  @override
  void dispose() {
    _sexController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _sidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('完善个人信息'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Avatar(
                  image: avatarImage,
                  onTap: onTapAvatar(context),
                ),
                FormInput(
                  icon: Icons.person,
                  controller: _sidController,
                  labelText: '学号',
                  enabled: false,
                ),
                FormInput(
                  icon: Icons.how_to_reg,
                  controller: _nameController,
                  labelText: '姓名',
                  enabled: false,
                ),
                FormInput(
                  icon: Icons.people,
                  controller: _sexController,
                  labelText: '性别',
                  enabled: false,
                ),
                FormInput(
                  icon: Icons.phone,
                  labelText: '手机号（可选）',
                  controller: _mobileController,
                  validator: (String value) {
                    if (value == '') return null;
                    return mobileRegExp.hasMatch(value.trim()) ? null : '手机号格式错误';
                  },
                ),
                FormInput(
                  icon: Icons.tag_faces,
                  labelText: '昵称',
                  controller: _nicknameController,
                  validator: (String value) {
                    return value.length != 0 ? null : '请输入用户名';
                  },
                ),
                BuildingListFormField(
                  onChanged: onChangeBuilding,
                  validator: (value) {
                    return value != null ? null : '请选择公寓楼栋';
                  },
                ),
                PrimaryButton(
                  text: '完成',
                  width: 300.w,
                  fontSize: 44.sp,
                  height: 80.h,
                  onPressed: onUpdateInfo,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
