import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:hatley_delivery/data/mappers/profile_mapper.dart';
import 'package:hatley_delivery/data/mappers/statistics_mapper.dart';

import '../../core/error/failure.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/entities/statistics_entity.dart';
import '../../domain/repo/profile_repo.dart';
import '../datasources/profile_datasource.dart';


class ProfileRepoImpl implements ProfileRepo {
  ProfileDatasource profileDatasource;
  ProfileRepoImpl(this.profileDatasource);

  @override
  Future<Either<Failure, ProfileEntity>> getProfileInfo() async {
    try {
      final profileResponse = await profileDatasource.getProfileInfo();
      final profileEntity = profileResponse.toEntity();
      return Right(profileEntity);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(File imagePath) async {
    try {
      final imageUrl = await profileDatasource.uploadProfileImage(imagePath);
      return Right(imageUrl);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      await profileDatasource.changePassword(oldPassword, newPassword);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfileInfo(
    String name,
    String email,
    String phone,
      String nationalId,
      int gov,
      int zone,
  ) async {
    try {
      await profileDatasource.updateProfileInfo(name, email, phone,nationalId,gov,zone);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StatisticsEntity>> getAllStatistics() async {
    try {
      final statisticsResponse = await profileDatasource.getAllStatistics();
      final statisticsEntity = statisticsResponse.toEntity();
      return Right(statisticsEntity);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
