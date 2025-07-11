import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/auth_entity.dart';

abstract class UserRepo {
  Future<Either<Failure, String>> registerUser({
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
  });

  Future<Either<Failure, AuthEntity>> loginUser({
    required String email,
    required String password
});

  Future<Either<Failure,String>> logOutUser();

}