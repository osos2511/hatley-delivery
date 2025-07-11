import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../../core/local/token_storage.dart';
import '../entities/auth_entity.dart';
import '../repo/user_repo.dart';

class SignInUseCase {
  final UserRepo userRepo;
  final TokenStorage tokenStorage;

  SignInUseCase(this.userRepo, this.tokenStorage);

  Future<Either<Failure, AuthEntity>> call({
    required String email,
    required String password,
  }) async {
    final result = await userRepo.loginUser(email: email, password: password);

    result.fold(
          (_) {},
          (authEntity) async {
        await tokenStorage.saveToken(authEntity.token, authEntity.expiration);
      },
    );

    return result;
  }
}
