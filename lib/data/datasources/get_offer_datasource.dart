import 'package:dio/dio.dart';
import 'package:hatley_delivery/data/model/offer_response.dart';
import 'package:hatley_delivery/data/model/offer_send_response.dart';

abstract class GetOfferDatasource {
  Future<OfferResponse> getOffer(num orderId);
  Future<OfferSendResponse> sendOffer({
    required int orderId,
    required String email,
    required num value,
  });
}

class GetOfferDatasourceImpl implements GetOfferDatasource {
  final Dio dio;
  GetOfferDatasourceImpl({required this.dio});

  @override
  Future<OfferResponse> getOffer(num orderId) async {
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

  @override
  Future<OfferSendResponse> sendOffer({
    required int orderId,
    required String email,
    required num value,
  }) async {
    try {
      final response = await dio.get(
        'offer/View',
        queryParameters: {'orderid': orderId, 'value': value, 'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OfferSendResponse.fromJson(response.data);
      } else {
        throw Exception('send offer is failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
