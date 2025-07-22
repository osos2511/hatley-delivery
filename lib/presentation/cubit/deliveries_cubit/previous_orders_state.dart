import 'package:hatley_delivery/domain/entities/previous_order_entity.dart';

abstract class PreviousOrdersState {}

class PreviousOrdersInitial extends PreviousOrdersState {}

class PreviousOrdersLoading extends PreviousOrdersState {}

class PreviousOrdersLoaded extends PreviousOrdersState {
  final List<PreviosOrdersEntity> orders;

  PreviousOrdersLoaded(this.orders);
}

class PreviousOrdersError extends PreviousOrdersState {
  final String message;

  PreviousOrdersError(this.message);
}
