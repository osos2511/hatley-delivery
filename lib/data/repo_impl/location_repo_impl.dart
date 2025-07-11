import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/error/failure.dart';
import '../../domain/entities/governorate_entity.dart';
import '../../domain/entities/zone_entity.dart';
import '../../domain/repo/location_repo.dart';
import '../datasources/get_all_governorate_datasource.dart';
import '../datasources/get_all_zoneBy_gov_name_datasource.dart';

class LocationRepoImpl implements LocationRepo {
  GetAllGovernorateRemoteDataSource remoteDataSource;
  GetAllZoneByGovNameRemoteDataSource zoneRemoteDataSource;
  LocationRepoImpl(this.remoteDataSource, this.zoneRemoteDataSource);
  @override
  Future<Either<Failure, List<GovernorateEntity>>> getAllGovernorate() async {
    try {
      final result = await remoteDataSource.getAllGovernorate();
      final entityList = result.map((e) => e.toEntity()).toList();
      return Right(entityList);
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ZoneEntity>>> getAllZoneByGovName({
    required String govName,
  }) async {
    try {
      final result = await zoneRemoteDataSource.getAllZoneByGovName(
        govName: govName,
      );
      final entityList = result.map((e) => e.toEntity()).toList();
      return Right(entityList);
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
