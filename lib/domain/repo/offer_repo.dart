import 'package:dartz/dartz.dart';
import 'package:hatley_delivery/core/error/failure.dart';
import 'package:hatley_delivery/domain/entities/offer_entity.dart';

abstract class OfferRepo {
  Future<Either<Failure, OfferEntity>> getOffer(String orderId);
}
