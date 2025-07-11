import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/getAllGovernorate_usecase.dart';
import 'governorate_state.dart';

class GovernorateCubit extends Cubit<GovernorateState> {
  final GetAllGovernorateUseCase getAllGovernorateUseCase;
  GovernorateCubit(this.getAllGovernorateUseCase) : super(GovernorateInitial());
  Future<void> fetchGovernorates() async {
    emit(GovernorateLoading());
    final result = await getAllGovernorateUseCase.call();

    result.fold(
      (failure) {
        print('fetch Governorates failed: ${failure.message}');
        emit(GovernorateError(failure.message));
      },

      (governorates) {
        print('fetch Governorates success: $governorates');
        emit(GovernorateLoaded(governorates));
      },
    );
  }
}
