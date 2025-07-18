import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:hatley_delivery/data/model/traking_response.dart';
import '../error/failure.dart';

class TrakingApiManager {
  final Dio dio;

  TrakingApiManager({required this.dio});

  Future<Either<Failure, dynamic>> getAllTrackingData() async {
    try {
      final response = await dio.get('Traking');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is List) {
          final List<dynamic> data = response.data;
          final List<TrakingResponse> trackingList = data
              .map((e) => TrakingResponse.fromJson(e as Map<String, dynamic>))
              .toList();
          return Right(trackingList);
        } else if (response.data is String) {
          // رجع النص مباشرة بدون تحقق
          return Right(response.data);
        } else {
          return Left(ServerFailure('Unexpected response format'));
        }
      } else if (response.statusCode == 400) {
        // تعامُل خاص مع رسالة "No exit orders"
        if (response.data is Map<String, dynamic> &&
            response.data['message'] == 'No exit orders') {
          return Right(<TrakingResponse>[]);
        }
        // لو بيانات نصية أو غيرها، يرجعها كخطأ عادي
        if (response.data is String) {
          return Left(ServerFailure(response.data));
        }
        return Left(
          ServerFailure('Failed to load tracking data: ${response.statusCode}'),
        );
      } else {
        if (response.data is String) {
          return Left(ServerFailure(response.data));
        }
        return Left(
          ServerFailure('Failed to load tracking data: ${response.statusCode}'),
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.unknown) {
        return Left(NetworkFailure("Please check your internet connection."));
      } else if (e.response != null) {
        return Left(
          ServerFailure(
            "Server error: ${e.response?.statusCode} - ${e.response?.data['message'] ?? 'Unknown error'}",
          ),
        );
      }
      return Left(
        ServerFailure('An unexpected Dio error occurred: ${e.message}'),
      );
    } catch (e) {
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }
}
