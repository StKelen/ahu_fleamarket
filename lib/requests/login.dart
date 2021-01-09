import 'package:dio/dio.dart';

import 'index.dart';
import 'package:flea_market/common/config/service_url.dart';

Future postLoginRequest(
    String uid, String password, Function resolve, Function reject) async {
  Response response;
  var loginData = {
    'uid': uid,
    'password': password,
  };
  try {
    response = await MyDio.dio.post(ServiceUrl.loginUrl, data: loginData);
    if (response.statusCode != 200) {
      reject('网络请求失败');
    } else {
      resolve(response.data);
    }
  } catch (e) {
    return reject('网络请求失败');
  }
}
