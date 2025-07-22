import 'package:dartz/dartz.dart';
import 'package:hatley_delivery/domain/entities/previous_order_entity.dart';
import 'package:hatley_delivery/domain/entities/related_orders_entity.dart';
import '../../core/error/failure.dart';

abstract class OrderRepo {
  Future<Either<Failure, List<RelatedOrdersEntity>>> getRelatedOrders();
  Future<Either<Failure, List<RelatedOrdersEntity>>> getUnrelatedOrders();
  Future<Either<Failure, List<PreviosOrdersEntity>>> previousOrders();
}
