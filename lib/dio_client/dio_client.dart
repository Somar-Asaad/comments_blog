import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  Dio? dio;
  String baseUrl = 'https://jsonplaceholder.typicode.com/';
  static DioClient? _instance;
  Map<String, dynamic> defaultHEADERS = {"Content-Type": "application/json"};

  DioClient._internal() {
    dio = Dio();
    dio?.options.baseUrl = baseUrl;
    dio?.options.headers = defaultHEADERS;
    dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
      ),
    );
  }

  static DioClient get instance {
    _instance ??= DioClient._internal();
    return _instance!;
  }
}
