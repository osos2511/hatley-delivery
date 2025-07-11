import 'package:dio/dio.dart';
import '../model/governorate_response.dart';

abstract class GetAllGovernorateRemoteDataSource {
  Future<List<GovernorateResponse>> getAllGovernorate();
}

class GetAllGovernorateDataSourceImpl
    implements GetAllGovernorateRemoteDataSource {
  final Dio dio;
  GetAllGovernorateDataSourceImpl({required this.dio});
  @override
  Future<List<GovernorateResponse>> getAllGovernorate() async {
    try {
      final response = await dio.get('Governorate');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List;
        return data.map((e) => GovernorateResponse.fromJson(e)).toList();
      } else {
        throw Exception('get Governorate is failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
