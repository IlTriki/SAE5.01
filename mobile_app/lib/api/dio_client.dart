import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            // base url will be changed to the db url later
            baseUrl: "http://localhost:3000",
            contentType: "application/json",
            headers: {
              "Accept": "application/json, plain/text, */*",
            },
          ),
        );

  Dio dio() {
    return _dio;
  }
}
