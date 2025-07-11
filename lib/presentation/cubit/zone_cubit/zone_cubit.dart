import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley_delivery/presentation/cubit/zone_cubit/zone_state.dart';
import '../../../domain/usecases/getAllZoneByGovName_usecase.dart';
class ZoneCubit extends Cubit<ZoneState> {
  final GetAllZoneByGovNameUseCase getAllZoneByGovNameUseCase;
  ZoneCubit(this.getAllZoneByGovNameUseCase) : super(ZoneInitial());
  Future<void> fetchZones({required String govName}) async {
    emit(ZonesLoading());
    final result = await getAllZoneByGovNameUseCase.call(govName: govName);

    result.fold(
          (failure) {
        print('fetch Zone failed: ${failure.message}');
        emit(ZoneError(failure.message));
      },

          (governorates) {
        print('fetch Governorates success: $governorates');
        emit(ZonesLoaded(governorates));
      },
    );
  }
}
