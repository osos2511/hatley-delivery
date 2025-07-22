import 'package:dartz/dartz.dart';
import 'package:hatley_delivery/core/error/failure.dart';
import 'package:hatley_delivery/domain/entities/previous_order_entity.dart';
import 'package:hatley_delivery/domain/repo/order_repo.dart';

class GetPreviousOrdersUseCase {
  OrderRepo orderRepo;
  GetPreviousOrdersUseCase(this.orderRepo);
  Future<Either<Failure, List<PreviosOrdersEntity>>> call() {
    return orderRepo.previousOrders();
  }
}
