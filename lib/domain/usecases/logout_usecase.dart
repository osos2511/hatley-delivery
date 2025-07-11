import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../repo/user_repo.dart';

class LogOutUseCase{
  UserRepo userRepo;
  LogOutUseCase(this.userRepo);
  Future<Either<Failure,String>> call(){
    return userRepo.logOutUser();
  }
}