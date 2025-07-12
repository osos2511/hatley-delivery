import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley_delivery/domain/entities/offer_entity.dart';
import 'package:hatley_delivery/domain/usecases/get_offer_usecase.dart';
import 'offer_state.dart';

class OfferCubit extends Cubit<OfferState> {
  final GetOfferUsecase getOfferUsecase;

  OfferCubit(this.getOfferUsecase) : super(OfferInitial());

  Future<void> getOffer(num orderId) async {
    emit(OfferLoading());
    final result = await getOfferUsecase.call(orderId);
    result.fold((failure) => emit(OfferFailure(failure.message)), (success) {
      emit(GetOfferSuccess(success));
    });
  }
}
