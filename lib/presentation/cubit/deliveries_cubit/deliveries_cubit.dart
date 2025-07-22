import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley_delivery/domain/usecases/previous_orders_usecase.dart';
import 'package:hatley_delivery/presentation/cubit/deliveries_cubit/previous_orders_state.dart';

class PreviousOrdersCubit extends Cubit<PreviousOrdersState> {
  GetPreviousOrdersUseCase getOrdersUsecase;
  PreviousOrdersCubit(this.getOrdersUsecase) : super(PreviousOrdersInitial());

  Future<void> getAllOrders() async {
    emit(PreviousOrdersLoading());
    final result = await getOrdersUsecase.call();
    result.fold(
      (failure) => emit(PreviousOrdersError(failure.message)),
      (deliveries) => emit(PreviousOrdersLoaded(deliveries)),
    );
  }
}
