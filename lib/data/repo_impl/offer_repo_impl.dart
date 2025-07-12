import 'package:dartz/dartz.dart';
import 'package:hatley_delivery/core/error/failure.dart';
import 'package:hatley_delivery/data/datasources/get_offer_datasource.dart';
import 'package:hatley_delivery/data/mappers/offer_mapper.dart';
import 'package:hatley_delivery/domain/entities/offer_entity.dart';
import 'package:hatley_delivery/domain/repo/offer_repo.dart';

class OfferRepoImpl implements OfferRepo {
  final GetOfferDatasource getOfferDatasource;
  OfferRepoImpl({required this.getOfferDatasource});

  @override
  Future<Either<Failure, OfferEntity>> getOffer(num orderId) async {
    try {
      final result = await getOfferDatasource.getOffer(orderId);
      final offerEntity = result.toEntity();
      return Right(offerEntity);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
