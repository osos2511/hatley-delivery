import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley_delivery/domain/entities/related_orders_entity.dart';
import 'package:hatley_delivery/domain/usecases/get_related_orders_usecase.dart';
import 'order_state.dart';

class GetAllOrdersCubit extends Cubit<OrderState> {
  List<RelatedOrdersEntity> orders = [];

  final GetRelatedOrdersUseCase relatedOrdersUseCase;
  final GetUnrelatedOrdersUseCase unrelatedOrdersUseCase;

  GetAllOrdersCubit(this.relatedOrdersUseCase, this.unrelatedOrdersUseCase)
    : super(OrderInitial());

  Future<void> getAllOrders() async {
    emit(OrderLoading());
    final relatedResult = await relatedOrdersUseCase.call();
    final unrelatedResult = await unrelatedOrdersUseCase.call();
    List<RelatedOrdersEntity> allOrders = [];
    String? error;
    relatedResult.fold(
      (failure) => error = failure.message,
      (success) => allOrders.addAll(success),
    );
    unrelatedResult.fold(
      (failure) => error = failure.message,
      (success) => allOrders.addAll(success),
    );
    if (error != null) {
      emit(OrderFailure(error!));
    } else {
      allOrders.sort((a, b) => b.orderId.compareTo(a.orderId));
      orders = allOrders;
      emit(GetAllOrdersSuccess(orders));
    }
  }
}
