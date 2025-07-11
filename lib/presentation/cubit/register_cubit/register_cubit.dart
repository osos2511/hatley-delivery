import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley_delivery/presentation/cubit/register_cubit/register_state.dart';
import '../../../domain/usecases/register_usecase.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase useCase;

  RegisterCubit(this.useCase) : super(RegisterInitial());

  Future<void> register({
    required String email,
    required String userName,
    required String password,
    required String phone,
    required String national_id,
    required int Governorate_ID,
    required int Zone_ID,
    required String frontImage,
    required String backImage,
    required String faceImage
  }) async {
    emit(RegisterLoading());

    final result = await useCase(
      email: email,
      userName: userName,
      password: password,
      phone: phone,
        frontImage: frontImage,
        faceImage: faceImage,
        backImage: backImage,
        Zone_ID: Zone_ID,
        Governorate_ID: Governorate_ID,
        national_id: national_id
    );

    result.fold(
      (failure) {
        print('register failed: ${failure.message}');
        emit(RegisterFailure(failure.message));
      },
      (message) {
        print('register success: $message');
        emit(RegisterSuccess(message));
      },
    );
  }
}
