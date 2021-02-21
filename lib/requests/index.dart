import 'package:dio/dio.dart';

import 'package:flea_market/provider/global.dart';

class MyDio {
  static BaseOptions options = BaseOptions(connectTimeout: 3000, receiveTimeout: 1000);

  static Future get(String url, Function resolve, Function reject) async {
    await _dio.get(url).then((value) {
      resolve(value.data);
    }).catchError((e) {
      var response = (e as DioError).response;
      if (response == null) {
        reject('网络异常');
      }
      reject(response.data['msg']);
    });
  }

  static Future post(String url, dynamic data, Function resolve, Function reject) async {
    await _dio.post(url, data: data).then((value) {
      if (value.headers != null && value.headers['Token'] != null) {
        String token = value.headers['Token'].first;
        GlobalModel.setToken(token);
      }
      resolve(value.data);
    }).catchError((e) {
      var response = (e as DioError).response;
      if (response == null) {
        reject('网络异常');
      }
      reject(response.data['msg']);
    });
  }

  static Future put(String url, {dynamic data, Function resolve, Function reject}) async {
    await _dio.put(url, data: data).then((value) {
      if (resolve != null) resolve(value.data);
    }).catchError((e) {
      if (reject == null) return;
      var response = (e as DioError).response;
      if (response == null) reject('网络异常');
      reject(response.data['msg']);
    });
  }

  static Future delete(String url, {dynamic data, Function resolve, Function reject}) async {
    await _dio.delete(url, data: data).then((value) {
      if (resolve != null) resolve(value.data);
    }).catchError((e) {
      if (reject == null) return;
      var response = (e as DioError).response;
      if (response == null) reject('网络异常');
      reject(response.data['msg']);
    });
  }

  static setToken(String t) {
    if (t == null || t == '') return;
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      options.headers.addAll({'Token': t});
      return options;
    }));
  }

  static Dio _dio = Dio(options);
}
