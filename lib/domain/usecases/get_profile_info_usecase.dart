import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/profile_entity.dart';
import '../repo/profile_repo.dart';

class GetProfileInfoUsecase {
  ProfileRepo profileRepo;
  GetProfileInfoUsecase(this.profileRepo);
  Future<Either<Failure, ProfileEntity>> call() {
    return profileRepo.getProfileInfo();
  }
}
