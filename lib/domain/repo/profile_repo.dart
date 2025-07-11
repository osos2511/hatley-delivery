import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/profile_entity.dart';
import '../entities/statistics_entity.dart';

abstract class ProfileRepo {
  Future<Either<Failure, ProfileEntity>> getProfileInfo();
  Future<Either<Failure, String>> uploadProfileImage(File imagePath);
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  );
  Future<Either<Failure, void>> updateProfileInfo(
    String name,
    String email,
    String phone,
      String nationalId,
      int gov,
      int zone,
  );
  Future<Either<Failure, StatisticsEntity>> getAllStatistics();
}
