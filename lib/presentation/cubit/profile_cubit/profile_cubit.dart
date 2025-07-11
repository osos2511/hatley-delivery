import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_profile_info_usecase.dart';
import '../../../domain/usecases/updateProfile_usecase.dart';
import '../../../domain/usecases/upload_profile_img_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileInfoUsecase getProfileInfoUseCase;
  final UploadProfileImgUsecase uploadProfileImgUsecase;
  final UpdateprofileUsecase updateProfileUsecase;

  ProfileCubit({
    required this.getProfileInfoUseCase,
    required this.updateProfileUsecase,
    required this.uploadProfileImgUsecase,
  }) : super(ProfileState());

  Future<void> getProfileInfo() async {
    if (isClosed) return;

    emit(state.copyWith(isLoadingProfile: true, errorMessage: null));

    final result = await getProfileInfoUseCase();

    if (isClosed) return;

    result.fold(
          (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            isLoadingProfile: false,
            errorMessage: failure.message,
          ),
        );
      },
          (profile) {
        if (isClosed) return;
        emit(
          state.copyWith(
            isLoadingProfile: false,
            profile: profile,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> uploadProfileImage(File imagePath) async {
    if (isClosed) return;

    emit(state.copyWith(isUploadingImage: true, errorMessage: null));

    final result = await uploadProfileImgUsecase(imagePath);

    if (isClosed) return;

    result.fold(
          (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            isUploadingImage: false,
            errorMessage: failure.message,
          ),
        );
      },
          (imageUrl) {
        if (isClosed) return;
        emit(
          state.copyWith(
            isUploadingImage: false,
            uploadedImageUrl: imageUrl,
            profile: state.profile?.copyWith(photo: imageUrl), // تحديث الصورة مباشرة
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> updateProfile(
      String name,
      String email,
      String phone,
      String nationalId,
      int governorateId,
      int zoneId,
      ) async {
    if (isClosed) return;

    emit(state.copyWith(isUpdatingProfile: true, errorMessage: null));

    final result = await updateProfileUsecase(
      name,
      email,
      phone,
      nationalId,
      governorateId,
      zoneId,
    );

    if (isClosed) return;

    result.fold(
          (failure) {
        if (isClosed) return;
        emit(state.copyWith(
          isUpdatingProfile: false,
          errorMessage: failure.message,
        ));
      },
          (_) async {
        if (isClosed) return;

        emit(state.copyWith(isUpdatingProfile: false));

        // ✅ بعد نجاح التحديث، إعادة جلب البيانات من الـ API
        await getProfileInfo();
      },
    );
  }

}