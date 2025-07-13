import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley_delivery/domain/usecases/get_offer_usecase.dart';
import 'package:hatley_delivery/domain/usecases/send_offer_usecase.dart';
import 'offer_state.dart';

class OfferCubit extends Cubit<OfferState> {
  final GetOfferUsecase getOfferUsecase;
  final SendOfferUseCase sendOfferUseCase;

  OfferCubit(this.getOfferUsecase, this.sendOfferUseCase)
    : super(OfferInitial());

  Future<void> getOffer(num orderId) async {
    emit(OfferLoading());
    final result = await getOfferUsecase.call(orderId);
    result.fold((failure) => emit(OfferFailure(failure.message)), (success) {
      emit(GetOfferSuccess(success));
    });
  }

  Future<void> sendOffer({
    required int orderId,
    required String email,
    required num value,
  }) async {
    print('sendOffer called');
    emit(SendOfferLoading());
    final result = await sendOfferUseCase.call(
      orderId: orderId,
      email: email,
      value: value,
    );
    result.fold(
      (failure) => emit(SendOfferFailure(failure.message)),
      (success) => emit(SendOfferSuccess(success)),
    );
  }
}
