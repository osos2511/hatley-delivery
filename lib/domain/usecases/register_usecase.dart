import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../repo/user_repo.dart';

class RegisterUseCase{
  final UserRepo userRepo;
  RegisterUseCase(this.userRepo);
  Future<Either<Failure,String>> call({
    required String userName,
    required String phone,
    required String email,
    required String password,
    required String national_id,
    required int Governorate_ID,
    required int Zone_ID,
    required String frontImage,
    required String backImage,
    required String faceImage

}
){
 return userRepo.registerUser(
     userName: userName,
     phone: phone,
     email: email,
     password: password,
 frontImage: frontImage,
   faceImage: faceImage,
   backImage: backImage,
   Zone_ID: Zone_ID,
   Governorate_ID: Governorate_ID,
   national_id: national_id
 );
  }
}