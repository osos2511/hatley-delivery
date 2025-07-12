import 'package:hatley_delivery/domain/entities/related_orders_entity.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {}

class GetAllOrdersSuccess extends OrderState {
  final List<RelatedOrdersEntity> orders;
  GetAllOrdersSuccess(this.orders);
}

class OrderFailure extends OrderState {
  final String error;
  OrderFailure(this.error);
}
