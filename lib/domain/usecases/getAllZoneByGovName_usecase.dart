import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/zone_entity.dart';
import '../repo/location_repo.dart';

class GetAllZoneByGovNameUseCase{
  LocationRepo locationRepo;
  GetAllZoneByGovNameUseCase(this.locationRepo);
  Future<Either<Failure,List<ZoneEntity>>> call({required String govName}){
    return locationRepo.getAllZoneByGovName(govName: govName);
  }
}