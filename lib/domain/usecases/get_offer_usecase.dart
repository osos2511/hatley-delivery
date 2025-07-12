import 'package:dartz/dartz.dart';
import 'package:hatley_delivery/domain/entities/offer_entity.dart';
import 'package:hatley_delivery/domain/repo/offer_repo.dart';
import '../../core/error/failure.dart';

class GetOfferUsecase {
  OfferRepo offerRepo;
  GetOfferUsecase(this.offerRepo);
  Future<Either<Failure, OfferEntity>> call(num orderId) {
    return offerRepo.getOffer(orderId);
  }
}
