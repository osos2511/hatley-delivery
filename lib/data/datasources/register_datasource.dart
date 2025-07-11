import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

abstract class RegisterRemoteDataSource {
  Future<String> registerUser({
    required String userName,
    required String phone,
    required String email,
    required String password,
    required String national_id,
    required int Governorate_ID,
    required int Zone_ID,
    required String frontImage,
    required String backImage,
    required String faceImage,
  });
}

class RegisterDataSourceImpl implements RegisterRemoteDataSource {
  final Dio dio;
  RegisterDataSourceImpl({required this.dio});

  @override
  Future<String> registerUser({
    required String userName,
    required String phone,
    required String email,
    required String password,
    required String national_id,
    required int Governorate_ID,
    required int Zone_ID,
    required String frontImage,
    required String backImage,
    required String faceImage,
  }) async {
    try {
      MultipartFile frontImageFile = await MultipartFile.fromFile(
        frontImage,
        filename: frontImage.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );

      MultipartFile backImageFile = await MultipartFile.fromFile(
        backImage,
        filename: backImage.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );

      MultipartFile faceImageFile = await MultipartFile.fromFile(
        faceImage,
        filename: faceImage.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );

      FormData formData = FormData.fromMap({
        'Name': userName,
        'Phone': phone,
        'Email': email,
        'Password': password,
        'national_id': national_id,
        'Governorate_ID': Governorate_ID,
        'Zone_ID': Zone_ID,
        'frontImage': frontImageFile,
        'backImage': backImageFile,
        'faceImage': faceImageFile,
      });

      final response = await dio.post(
        'DeliveryAccount/register',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data.toString();
      } else {
        throw Exception('Register failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
