import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repo/user_repo.dart';
import '../datasources/logout_remote_datasource.dart';
import '../datasources/register_datasource.dart';
import '../datasources/signIn_datasource.dart';

class UserRepoImpl implements UserRepo {
  final RegisterRemoteDataSource registerRemoteDataSource;
  final SignInRemoteDataSource signInRemoteDataSource;
  final LogOutRemoteDatasource logOutRemoteDatasource;

  UserRepoImpl(
    this.registerRemoteDataSource,
    this.signInRemoteDataSource,
    this.logOutRemoteDatasource,
  );

  @override
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
  }) async {
    try {
      final result = await registerRemoteDataSource.registerUser(
        userName: userName,
        phone: phone,
        email: email,
        password: password,
        national_id: national_id,
        Governorate_ID: Governorate_ID,
        Zone_ID: Zone_ID,
        backImage: backImage,
        faceImage: faceImage,
        frontImage: frontImage
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final result = await signInRemoteDataSource.signInUser(
        email: email,
        password: password,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> logOutUser() async {
    try {
      final result = await logOutRemoteDatasource.logOut();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
