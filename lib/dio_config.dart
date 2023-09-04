import 'package:dio/dio.dart';
import 'package:quanto/util/constants.dart';
import 'package:quanto/main.dart';

Dio dioInstance() {
  Dio dio = Dio();

  dio.options.baseUrl = Constants.apiUrl;
  if (sharedPreferences != null) {
    dio.options.headers['Authorization'] =
        'Bearer ${sharedPreferences!.getString('token')}';
  }
  return dio;
}
