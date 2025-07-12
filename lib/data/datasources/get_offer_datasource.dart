import 'package:dio/dio.dart';
import 'package:hatley_delivery/data/model/offer_response.dart';

abstract class GetOfferDatasource {
  Future<OfferResponse> getOffer(String orderId);
}

class GetOfferDatasourceImpl implements GetOfferDatasource {
  final Dio dio;
  GetOfferDatasourceImpl({required this.dio});

  @override
  Future<OfferResponse> getOffer(String orderId) async {
    try {
      final response = await dio.get(
        'offer',
        queryParameters: {'orderid': orderId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OfferResponse.fromJson(response.data);
      } else {
        throw Exception('get offer is failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
