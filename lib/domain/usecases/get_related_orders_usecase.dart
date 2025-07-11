import 'package:dartz/dartz.dart';
import 'package:hatley_delivery/domain/entities/related_orders_entity.dart';
import '../../core/error/failure.dart';
import '../repo/order_repo.dart';

class GetRelatedOrdersUseCase {
  OrderRepo orderRepo;
  GetRelatedOrdersUseCase(this.orderRepo);
  Future<Either<Failure, List<RelatedOrdersEntity>>> call() {
    return orderRepo.getRelatedOrders();
  }
}