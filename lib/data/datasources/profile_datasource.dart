import 'dart:io';
import 'package:dio/dio.dart';
import '../model/profile_response.dart';
import '../model/statistics_response.dart';

abstract class ProfileDatasource {
  Future<ProfileResponse> getProfileInfo();
  Future<String> uploadProfileImage(File imagePath);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> updateProfileInfo(
    String name,
    String email,
    String phone,
    String nationalId,
    int gov,
    int zone,
  );
  Future<StatisticsResponse> getAllStatistics();
}

class ProfileDataSourceImpl implements ProfileDatasource {
  final Dio dio;
  ProfileDataSourceImpl({required this.dio});
  @override
  Future<ProfileResponse> getProfileInfo() async {
    try {
      final response = await dio.get('Delivery/profile');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProfileResponse.fromJson(response.data);
      } else {
        throw Exception('Get profile info failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<String> uploadProfileImage(File imagePath) async {
    try {
      final formData = FormData.fromMap({
        'profile_img': await MultipartFile.fromFile(
          imagePath.path,
          filename: imagePath.path.split('/').last,
        ),
      });
      final response = await dio.post('Delivery/uploadImage', data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data.toString();
      } else {
        throw Exception('Upload profile image failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      final response = await dio.post(
        'Delivery/changepassword',
        data: {'old_password': oldPassword, 'new_password': newPassword},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Change password failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> updateProfileInfo(
    String name,
    String email,
    String phone,
    String nationalId,
       int Governorate_ID,
       int Zone_ID,
  ) async {
    try {
      final response = await dio.put(
        'Delivery',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'national_id': nationalId,
          'governorate_ID': Governorate_ID,
          'zone_ID': Zone_ID,
        },
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Update profile info failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<StatisticsResponse> getAllStatistics() async {
    try {
      final response = await dio.get('Order/Statistics');
      if (response.statusCode == 200) {
        return StatisticsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load statistics');
      }
    } catch (e) {
      throw Exception('Failed to load statistics: $e');
    }
  }
}
