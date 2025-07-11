import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'local/token_storage.dart';

class DioFactory {
  static Future<Dio> createDio() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenStorage = TokenStorageImpl(prefs);

    final BaseOptions options = BaseOptions(
      baseUrl: "https://hatley.runasp.net/api/",
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        "Accept": "*/*",
      },
    );

    final dio = Dio(options);

    // ✅ إضافة التوكن إلى الهيدر
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    // ✅ PrettyDioLogger في Debug فقط
    const isProduction = bool.fromEnvironment('dart.vm.product');
    if (!isProduction) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ));
    }

    return dio;
  }
}
