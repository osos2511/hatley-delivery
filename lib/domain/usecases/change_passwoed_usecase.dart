import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../repo/profile_repo.dart';

class ChangePasswordUsecase {
  final ProfileRepo profileRepo;

  ChangePasswordUsecase(this.profileRepo);

  Future<Either<Failure, void>> call(String oldPassword, String newPassword) {
    return profileRepo.changePassword(oldPassword, newPassword);
  }
}
