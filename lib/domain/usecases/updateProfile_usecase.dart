import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../repo/profile_repo.dart';

class UpdateprofileUsecase {
  final ProfileRepo profileRepo;

  UpdateprofileUsecase(this.profileRepo);

  Future<Either<Failure, void>> call(
    String name,
    String email,
    String phone,
      String nationalId,
      int gov,
      int zone,
  ) async {
    return await profileRepo.updateProfileInfo(name, email, phone,nationalId,gov,zone);
  }
}
