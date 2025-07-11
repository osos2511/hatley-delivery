import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/governorate_entity.dart';
import '../entities/zone_entity.dart';

abstract class LocationRepo{
  Future<Either<Failure,List<GovernorateEntity>>> getAllGovernorate();
  Future<Either<Failure,List<ZoneEntity>>> getAllZoneByGovName({required String govName});
}