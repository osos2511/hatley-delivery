import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley_delivery/domain/entities/related_orders_entity.dart';
import 'package:hatley_delivery/domain/usecases/get_related_orders_usecase.dart';
import 'order_state.dart';

class GetRelatedOrdersCubit extends Cubit<OrderState> {
  List<RelatedOrdersEntity> orders = [];

  final GetRelatedOrdersUseCase relatedOrdersUseCase;

  GetRelatedOrdersCubit(this.relatedOrdersUseCase) : super(OrderInitial());

  Future<void> getRelatedOrders() async {
    emit(OrderLoading());
    final result = await relatedOrdersUseCase.call();
    result.fold((failure) => emit(OrderFailure(failure.message)), (success) {
      success.sort((a, b) => b.orderId.compareTo(a.orderId));
      orders = success;
      emit(GetAllOrdersSuccess(orders));
    });
  }
}
