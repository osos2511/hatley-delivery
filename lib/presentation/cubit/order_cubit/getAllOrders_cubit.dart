import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley_delivery/domain/entities/related_orders_entity.dart';
import 'package:hatley_delivery/domain/entities/offer_entity.dart';
import 'package:hatley_delivery/domain/usecases/get_related_orders_usecase.dart';
import 'package:hatley_delivery/domain/usecases/get_offer_usecase.dart';
import 'order_state.dart';

class GetRelatedOrdersCubit extends Cubit<OrderState> {
  List<RelatedOrdersEntity> orders = [];
  OfferEntity? currentOffer;

  final GetRelatedOrdersUseCase relatedOrdersUseCase;
  final GetOfferUsecase getOfferUsecase;

  GetRelatedOrdersCubit(this.relatedOrdersUseCase, this.getOfferUsecase)
    : super(OrderInitial());

  Future<void> getRelatedOrders() async {
    emit(OrderLoading());
    final result = await relatedOrdersUseCase.call();
    result.fold((failure) => emit(OrderFailure(failure.message)), (success) {
      success.sort((a, b) => b.orderId.compareTo(a.orderId));
      orders = success;
      emit(GetAllOrdersSuccess(orders));
    });
  }

  Future<void> getOffer(String orderId) async {
    emit(OrderLoading());
    final result = await getOfferUsecase.call(orderId);
    result.fold((failure) => emit(OrderFailure(failure.message)), (success) {
      currentOffer = success;
      emit(GetOfferSuccess(success));
    });
  }
}
