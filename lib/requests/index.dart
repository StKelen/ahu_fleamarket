import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDio {
  static BaseOptions options =
      BaseOptions(connectTimeout: 3000, receiveTimeout: 1000);

  static Future get(String url, Function resolve, Function reject) async {
    await MyDio.dio.get(url).then((value) {
      resolve(value.data);
    }).catchError((e) {
      var response = (e as DioError).response;
      if (response == null) {
        reject('网络异常');
        return null;
      }
      reject(response.data['msg']);
      return null;
    });
  }

  static Future post(
      String url, dynamic data, Function resolve, Function reject) async {
    var response = await MyDio.dio.post(url, data: data).catchError((e) {
      var response = (e as DioError).response;
      if (response == null) {
        reject('网络异常');
        return;
      }
      reject(response.data['msg']);
    });
    if (response.headers != null && response.headers['Token'] != null) {
      String token = response.headers['Token'].first;
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString("Token", token);
      addToken();
    }
    resolve(response.data);
  }

  static addToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.get("Token");
    if (token == null || (token as String).length == 0) return;
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      options.headers.addAll({'Token': token as String});
      return options;
    }));
  }

  static Dio dio = Dio(options);
}
