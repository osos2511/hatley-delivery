import 'package:dio/dio.dart';

abstract class LogOutRemoteDatasource {
  Future<String> logOut();
}

class LogOutDatasourceImpl implements LogOutRemoteDatasource {
  final Dio dio;
  LogOutDatasourceImpl({required this.dio});
  @override
  Future<String> logOut() async {
    try {
      final response = await dio.get('DeliveryAccount/logout');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['message'];
      } else {
        throw Exception('Logout failed');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
