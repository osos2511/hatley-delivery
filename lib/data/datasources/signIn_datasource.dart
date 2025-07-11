import 'package:dio/dio.dart';
import '../model/sign_in_response.dart';

abstract class SignInRemoteDataSource {
  Future<SignInResponse> signInUser({
    required String email,
    required String password,
  });
}

class SignInDataSourceImpl implements SignInRemoteDataSource {
  final Dio dio;

  SignInDataSourceImpl({required this.dio});

  @override
  Future<SignInResponse> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        'DeliveryAccount/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SignInResponse.fromJson(response.data);
      } else {
        throw Exception('Sign in failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
