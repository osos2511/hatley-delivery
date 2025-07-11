import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/statistics_entity.dart';
import '../repo/profile_repo.dart';

class GetallStatisticsUsecase {
  final ProfileRepo statisticsRepo;

  GetallStatisticsUsecase(this.statisticsRepo);

  Future<Either<Failure, StatisticsEntity>> call() async {
    return await statisticsRepo.getAllStatistics();
  }
}
