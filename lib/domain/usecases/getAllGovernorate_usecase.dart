import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/governorate_entity.dart';
import '../repo/location_repo.dart';


class GetAllGovernorateUseCase{
  LocationRepo locationRepo;
  GetAllGovernorateUseCase(this.locationRepo);
  Future<Either<Failure,List<GovernorateEntity>>> call(){
    return locationRepo.getAllGovernorate();
  }
}