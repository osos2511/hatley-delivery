import 'package:dio/dio.dart';
import 'package:hatley_delivery/data/model/RelatedOrdersResponse.dart';

abstract class GetRelatedOrdersDataSource {
  Future<List<RelatedOrdersResponse>> getAllRelatedOrders();
}

class GetRelatedOrdersDataSourceImpl implements GetRelatedOrdersDataSource {
  final Dio dio;
  GetRelatedOrdersDataSourceImpl({required this.dio});

  @override
  Future<List<RelatedOrdersResponse>> getAllRelatedOrders() async {
    try {
      final response = await dio.get('Order/related/orders');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data == null || (data is List && data.isEmpty)) {
          return [];
        }
        return (data as List)
            .map((e) => RelatedOrdersResponse.fromJson(e))
            .toList();
      } else {
        throw Exception(
          'Failed to fetch orders with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 &&
          e.response?.data == "No Records exist") {
        return [];
      }
      throw Exception('Network error: ${e.message}');
    }
  }
}
