import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hatley_delivery/data/datasources/get_orders_datasource.dart';
import 'package:hatley_delivery/data/mappers/related_orders_mapper.dart';
import 'package:hatley_delivery/domain/entities/related_orders_entity.dart';
import 'package:hatley_delivery/domain/repo/order_repo.dart';
import '../../core/error/failure.dart';

class OrderRepoImpl implements OrderRepo {
  GetRelatedOrdersDataSource relatedOrdersDataSource;
  OrderRepoImpl(this.relatedOrdersDataSource);
  @override
  Future<Either<Failure, List<RelatedOrdersEntity>>> getRelatedOrders() async {
    try {
      final result = await relatedOrdersDataSource.getAllRelatedOrders();
      final entityList = result.map((e) => e.toEntity()).toList();
      return Right(entityList);
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RelatedOrdersEntity>>>
  getUnrelatedOrders() async {
    try {
      final result = await relatedOrdersDataSource.getAllUnrelatedOrders();
      final entityList = result.map((e) => e.toEntity()).toList();
      return Right(entityList);
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
